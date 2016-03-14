//
//  SampleObjects.swift
//  Sample
//
//  Created by KimChangsung on 2/29/16.
//  Copyright © 2016 Changsung. All rights reserved.
//

import RealmSwift

class Card: Object {
    dynamic var id = ""
    dynamic var title = ""
    let address = Optional<Int>()
    let categoryIds  = List<CSRString>()
    
    class func categoryIdsJSONTransformer() -> NSValueTransformer {
        return CSRStringJSONTransformer()
    }
    
    override class func JSONOutboundMappingDictionary() -> [String:String] {
        return [
            "id": "id",
            "title": "title",
            "address": "address",
            "category_ids":"categoryIds"
        ]
    }
    
    override class func JSONInboundMappingDictionary() -> [String:String] {
        return [
            "id": "id",
            "title": "title",
            "address": "address",
            "category_ids":"categoryIds"
        ]
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Person:Object {
    dynamic var name:String?
    let cards = List<Card>()
}