//
//  Object+JSON.swift
//  betweendate
//
//  Created by KimChangsung on 2/11/16.
//  Copyright © 2016 VCNC. All rights reserved.
//

import RealmSwift

var outboundMappingForClassName = [String:[String:String]]()
var inboundMappingForClassName = [String:[String:String]]()

extension Object {
    
    convenience init(jsonDictionary dictionary:[String:AnyObject]) {
        self.init(value:self.dynamicType.createJSONObjectFromJSONDictionary(dictionary))
    }
    
    class func createJSONObjectFromJSONDictionary(dictionary:[String:AnyObject]) -> [String:AnyObject] {
        var result = [String:AnyObject]()
        let inboundMapping = inBoundMapping()
        for property in sharedSchema().properties {
            let propertyName = property.name
            guard let inboundKeyName = inboundMapping[propertyName] else {continue}
            var value = dictionary[inboundKeyName]
            if (value != nil) {
                //                if let transformer = transformerForPropertyKey(propertyName)  { // 현재 쓰고있는 transformer가 없어서 지워놨어요 (성능)
                //                    value = transformer.reverseTransformedValue(value)
                //                } else {
                switch (property.type) {
                case .Date:
                    value = BDCJSONDateTransformer().reverseTransformedValue(value)
                case .Object:
                    guard let className = property.objectClassName else {continue}
                    guard let aClass = RLMSchema.classForString(className) as? Object.Type else {continue}
                    value = aClass.createJSONObjectFromJSONDictionary(value as! [String:AnyObject])
                case .Array:
                    var array = [AnyObject]()
                    guard let aValue = value as? [[String:AnyObject]] else {continue}
                    guard let className = property.objectClassName else {continue}
                    guard let aClass = RLMSchema.classForString(className) as? Object.Type else {continue}
                    for item in aValue {
                        array.append(aClass.createJSONObjectFromJSONDictionary(item))
                    }
                    value = array
                default:()
                }
                //                }
                
                result[propertyName] = value
            }
        }
        return result
    }
    
    func JSONDictionary() -> [String:AnyObject] {
        return createJSONDictionary()
    }
    
    private func createJSONDictionary() -> [String:AnyObject] {
        var result = [String:AnyObject]()
        let mapping = self.dynamicType.outBoundMapping()
        for property in objectSchema.properties {
            let value = valueForKey(property.name)
            guard let propertyName = mapping[property.name] else {continue}
            if let transformer = self.dynamicType.transformerForPropertyKey(propertyName) {
                result[propertyName] = transformer.reverseTransformedValue(value)
            } else {
                switch (property.type) {
                case .Date:
                    let transFormedValue = BDCJSONDateTransformer().reverseTransformedValue(value)
                    result[propertyName] = transFormedValue
                case .Object:
                    guard let object = value as? Object else {continue}
                    result[propertyName] = object.createJSONDictionary()
                case .Array:
                    var array = [[String:AnyObject]]()
                    guard let aValue = value as? List else {continue}
                    for item in aValue {
                        array.append(item.createJSONDictionary())
                    }
                    result[propertyName] = array
                default:
                    result[propertyName] = value
                }
            }
        }
        return result
    }
    
    class func transformerForPropertyKey(keyPath:String) -> NSValueTransformer? {
        let selector = NSSelectorFromString(keyPath + "JSONTransformer")
        var transformer:NSValueTransformer?
        if (respondsToSelector(selector)) {
            transformer = performSelector(selector).takeUnretainedValue() as? NSValueTransformer
        }
        return transformer
    }
    
    class func outBoundMapping() -> [String:String] {
        if let mapping = outboundMappingForClassName[className()] {
            return mapping
        } else {
            let dictionary = JSONOutboundMappingDictionary()
            outboundMappingForClassName[className()] = dictionary
            return dictionary
        }
    }
    
    class func inBoundMapping() -> [String:String] {
        if let mapping = inboundMappingForClassName[className()] {
            return mapping
        } else {
            var dictionary = [String:String]()
            JSONInboundMappingDictionary().forEach({ (key, value) -> () in
                dictionary[value] = key
            })
            inboundMappingForClassName[className()] = dictionary
            return dictionary
        }
    }
    
    class func JSONOutboundMappingDictionary() -> [String:String] {
        var result = [String:String]()
        let properties = sharedSchema().properties
        for property in properties {
            result[property.name] = property.name
        }
        return result
    }
    
    class func JSONInboundMappingDictionary() -> [String:String] {
        var result = [String:String]()
        let properties = sharedSchema().properties
        for property in properties {
            result[property.name] = property.name
        }
        return result
    }
}

class BDCJSONDateTransformer:NSValueTransformer {
    let formatter = NSDateFormatter()
    
    override init() {
        super.init()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let value = value as? String {
            return formatter.dateFromString(value)
        }
        return nil
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let value = value as? NSDate {
            return formatter.stringFromDate(value)
        }
        return nil
    }
}