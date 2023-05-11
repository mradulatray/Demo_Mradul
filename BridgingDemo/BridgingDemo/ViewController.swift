//
//  ViewController.swift
//  BridgingDemo
//
//  Created by mradulatray on 31/03/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let obj = ObjFile()
        obj.callingMethod()
    }


}

class DemoClass: NSObject {
    
    override init () {
        print("demo class init ho gyi")
    }
    
    @objc func demoClassFunction() {
        print("ye demo class function he jo ki swift me likha he or objective file se call ho rha he")
    }
}

