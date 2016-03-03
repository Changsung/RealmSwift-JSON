# RealmSwift-JSON
Easy to transform to RealmSwift Object &lt;-> JSON inspired from matthewcheok/Realm-JSON(https://github.com/matthewcheok/Realm-JSON)

##Installation
just copy files in the ```RealmSwift-JSON``` folder into your project and add the under code in objective-c bridging-header 

    #import <Realm/RLMProperty.h>
    #import <Realm/RLMObjectSchema.h>
    #import <Realm/RLMObject_Private.h>
    #import <Realm/Realm.h>
  
  
##Using RealmSwift-JSON 
    class card:Object {
        dynamic var id = "" 
        dynamic var title:String?
        let persons = List<Person>()
    
        class func JSONInboundMappingDictionary() -> [String:String] {
            return [
                "id": "id",
                "title": "title",
                "card_persons":"persons"
            ]
        }
    }
    
    class person:Object {
        dynamic var id = ""
        dynamic var name = "" 
        
        class func JSONOutboundMappingDictionary() -> [String:String] {
            return [
                "id": "id",
                "person_name": "name"
            ]
        }
    }
    
    let person = Person(jsonDictionary:["id":"0", "person_name":"henry"])
    Realm().create(card.self, jsonDictionary:["id":"0", "title":"Seoul", card_persons:[["id":"0", "name":"person1"]] ], update: true)
    print(person.JSONDictionary())
    
You can also use ```NSValueTransformer```  like Mantle way as follows:

    class category:Object {
        let addesses = List<CSRString>()
        
        class func addressesJSONTransformer() -> NSValueTransformer {
            return CSRStringJSONTransformer()
        }
    }
    
    class CSRString:Object {
        dynamic var stringValue = "" 
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
    
## License

RealmSwift+JSON is under the MIT license.
    
