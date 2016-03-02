//
//  CSRString.swift
//  RealmSwift
//
//  Created by KimChangsung on 2/11/16.
//  Copyright © 2016 Changsung. All rights reserved.
//

import RealmSwift

class CSRString: Object {
    dynamic var stringValue = ""
}


extension CSRString {
    class func listOfStrings(array:[String]) -> [CSRString] {
        var result = [CSRString]()
        for item in array {
            let str = CSRString()
            str.stringValue = item
            result.append(str)
        }
        return result
    }
}


class CSRStringJSONTransformer: NSValueTransformer {
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        let rString = List<CSRString>()
        if let value = value as? [String] {
            for string in value {
                let str = CSRString()
                str.stringValue = string
                rString.append(str)
            }
            return rString
        } else {
            return super.transformedValue(value)
        }
    }
    
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let stringArray = value as? List<CSRString> {
            var strings = [String]()
            for rString in stringArray {
                strings.append(rString.stringValue)
            }
            return strings.count > 0 ? strings : nil
        } else {
            return super.reverseTransformedValue(value)
        }
    }
}