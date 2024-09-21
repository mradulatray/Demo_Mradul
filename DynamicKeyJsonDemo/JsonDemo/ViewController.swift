//
//  ViewController.swift
//  JsonDemo
//
//  Created by mradulatray on 20/09/24.
//

import UIKit
import SwiftyJSON


var json = 

"""
{
    "data" : [
        {
            "1" : {
                "name": "Mradul1"
            }
        },
        {
            "2" : {
                "name": "Mradul1"
            }
        },
        {
            "3" : {
                "name": "Mradul1"
            }
        },
        {
            "4" : {
                "name": "Mradul1"
            }
        },
        {
            "5" : {
                "name": "Mradul1"
            }
        },
        {
            "6" : {
                "name": "Mradul1"
            }
        }
    
    ]
}
"""
struct Name{
    
    var id: String
    var name: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
}
struct ModelData {
    var data:[Tag]
    
    init(_ json: JSON) {
        data = json["data"].arrayValue.map({ jsondata in
            
            return Tag(jsondata)
        })
    }
}

struct Tag {
    var dar: Name
    
    init(_ json: JSON) {
        
        let id = json.dictionaryObject?.keys
        let value = json.dictionaryObject?.values
        if let id = id, let value {
            let idValue = Array(id)
            let keysString = idValue.joined(separator: ", ")
            let valueValue = Array(value)
            let valueString = idValue.joined(separator: ", ")
            dar = Name(name: valueString, id: keysString)
        } else {
            dar = Name(name: "", id: "")
        }
    }
}




class ViewController: UIViewController {
    var data:ModelData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let jsonData = json.data(using: .utf8) else {
            return
        }
            do {
                // Convert JSON data to a dictionary
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    print(jsonDict)
                    data = ModelData(JSON(rawValue: jsonDict)!)
                    print(data)
                }
            } catch {
                print("Failed to convert string to JSON: \(error.localizedDescription)")
            }
        
        
        
        
        
        
    }


}

