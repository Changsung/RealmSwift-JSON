//
//  ViewController.swift
//  Sample
//
//  Created by KimChangsung on 3/2/16.
//  Copyright © 2016 Changsung. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            realm.beginWrite()
            let cardDict1 = ["id":"id0",
                "title":"test card1",
                "address":"Seoul",
                "category_ids":["category0", "category1"]]
            let card = Card(jsonDictionary:cardDict1)
            realm.add(card, update:true)
            let cardDict2 = ["id":"id1",
                "title":"test card2",
                "address":"Incheon",
                "category_ids":["category1", "category2"]]
            realm.create(Card.self, jsonDictionary:cardDict2, update: true)
            let personDict = [
                "name":"henry",
                "cards":[["id":"1",
                    "title":"test card2",
                    "address":"Incheon",
                    "category_ids":["category1", "category2"]]
                ]]
            let person = Person(jsonDictionary:personDict)
            print(person)
            /*
            Person {
                name = henry;
                cards = List<Card> (
                    [0] Card {
                        id = 1;
                        title = test card2;
                        categoryIds = List<CSRString> (
                            [0] CSRString {
                                stringValue = category1;
                            },
                            [1] CSRString {
                                stringValue = category2;
                            }
                        );
                    }
                );
            }*/
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

