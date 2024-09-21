//
//  ViewController.swift
//  DTDLDemo
//
//  Created by mradulatray on 11/05/24.
//

import UIKit

class Demo1 {
    
    func functionality() {
        print("Demo1")
    }
}

class  Demo2: Demo1 {
    
    override func functionality() {
        super.functionality()
        print("Demo2")
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        let objDemo2 = Demo2()
//        objDemo2.functionality()
        
        
        
        print("1")
        DispatchQueue.global().async {
            print("2")
            DispatchQueue.main.sync {
                print("3")
            }
            print("4")
        }
        print("5")
        
        
        
    }


}

