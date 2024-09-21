//
//  ViewController.swift
//  WheelsEyeDemo
//
//  Created by mradulatray on 09/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let arr =    [1, 5, 3, 2, 2, 2, 1, 2]
//        var newArr = [0,0,0,0,0,0,0,0]
//        var dict:[Int: Int] = [:]
//
//        
//        for val in arr {
//            newArr[val] = newArr[val] + 1
//        }
//          print(newArr)
//        for (index, value) in newArr.enumerated() {
//            if value != 0 {
//                print(index, value)
//            }
//        }
        checkValideString()
    }
    
    func givePair(pair: String) -> String {
        switch pair {
        case ")":
            return "("
        case "}":
            return "{"
        case "]":
            return "["
        default:
            return ""
        }
    }
    
    func checkValideString() {
        let arr  =   ["(", "(",")", ")", "{", "}", "[" , "]"]
        var newArr: [String] = []
        var pointer = 0
        for (index,val) in arr.enumerated() {
            if index != 0 {
               let pair = givePair(pair: val)
                if newArr[pointer] == pair{
                    newArr.remove(at: pointer)
                    pointer -= 1
                } else {
                    
                    newArr.append(val)
                    pointer += 1
                }
            } else {
                newArr.append(val)
//                pointer += 1
            }
        }
       print(newArr)
    }
    


}

