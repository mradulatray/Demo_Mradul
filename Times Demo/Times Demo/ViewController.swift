//
//  ViewController.swift
//  Times Demo
//
//  Created by mradulatray on 06/04/23.
//

import UIKit

class Person: NSObject {
   @objc dynamic var name: String = "mradul"
    var email: String = "mradul@gmail.com"
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var obj = Person()
        obj.name = "atray"
        print(obj.name)
        
        print(obj.value(forKey: "name"))
        
        obj.observe(\.name) { Person, value in
            print(value.oldValue)
            print(value.newValue)
        }
        
        
        
//        // Do any additional setup after loading the view.
//        //      let arr = ["1","2","3","4","nil","5"].compactMap { val in
//        //          if let value = Int(val){
//        //              return value
//        //          } else {
//        //              return nil
//        //          }
//        //        }
//
//        let arr = ["1","2","3","4","nil","5"].customMap { val in
//            if let value = Int(val){
//                return value
//            } else {
//                return nil
//            }
//        }
//
////        let a = ["1", "2", "shdh"]
////        let c = a.myCompactMap{Int($0)}
////        let s = a.myCompactMap { val in
////            return Int(val)
////        }
    }
}

extension Array {
    
    func customMap<T>(val:(Element)-> T?) -> [T] {
        var arr:[T] = []
        for value in self {
            if let newVal = val(value) {
                arr.append(newVal)
            }
        }
        return arr
    }
}

extension Array {
    func myCompactMap<Transform>(transform: (Element)-> Transform?) -> [Transform] {
        var result = [Transform]()
        forEach { element in
            if let transformedEntity = transform(element) {
            result.append(transformedEntity)
            }
        }
        return result
    }
}
