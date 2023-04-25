//
//  ViewController.swift
//  MMTDemo
//
//  Created by mradulatray on 01/04/23.
//

import UIKit

class ViewController: UIViewController {
    var arr:[String] = ["Mohit","Mradul" , "Mohit" ]
    var givenArr:[String] = []
    var newArr:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //         Given a string representing an arithmetic expression with only addition and multiplication operators, return the result of the calculation.
        //         ==Examples==
        //         expression → "2*3+4" return 10
        //         expression → “2+4+5” return 11
        //         expression → “4*3+2+3*6” return 32
        //         expression → “1+100*2” return 201
        
        // Example usage:
//        if let result = evaluateExpression("4*3+2+3*6") {
//            print(result)
//        } else {
//            print("Error evaluating expression")
//        }
    
        var array = ["1", "+", "100", "*", "2"]//, "+", "3", "*", "6"]
        let a = performMultiPlication(givenArr: &array)
        var result = 0
        for value in a {
            result += Int(value) ?? 0
        }
        print(result)
    }
    
    func evaluateExpression(_ expression: String) -> Int? {
        let expressionComponents = expression.components(separatedBy: CharacterSet.symbols.subtracting(CharacterSet(charactersIn: "+-*/")))
        let nsExpression = NSExpression(format: expressionComponents.joined())
        guard let result = nsExpression.expressionValue(with: nil, context: nil) as? Int else {
            return nil
        }
        return result
    }
    
    func performMultiPlication(givenArr: inout [String]) -> [String] {
        var i = 0
        while(i<givenArr.endIndex-2) {
            if givenArr[i+1] == "*" {
                let result = (Int(givenArr[i]) ?? 1) * (Int(givenArr[i+2]) ?? 1)
                givenArr[i] = "^"
                givenArr[i+1] = "^"
                givenArr[i+2] = "\(result)"
                i += 2
            }
            i += 1
        }
        return givenArr
    }

   
    
    
    func performOperations(givenArr: inout [String]) -> [String] {
        var isAllConverted:Bool = true
        for val in givenArr {
            if val != "*" {
                isAllConverted = false
                break
            }
        }
        if isAllConverted {
            return givenArr
        } else {
            var i = 0
            while(i<givenArr.endIndex-2) {
                if givenArr[i+1] == "*" {
                    let result = (Int(givenArr[i]) ?? 1) * (Int(givenArr[i+2]) ?? 1)
                    givenArr[i] = "^"
                    givenArr[i+1] = "^"
                    givenArr[i+2] = "\(result)"
                    i += 2
                }
                i += 1
            }
           
            for val in givenArr {
                if val != "^" {
                    newArr.append(val)
                }
            }
            return performOperations(givenArr: &newArr)
        }
    }
}

