//
//  ViewController.swift
//  @stateDemo
//
//  Created by mradulatray on 22/03/23.
//

import UIKit

struct Persone {
    
    @State var name: String
    var email: String
    var add: String
    
    internal init(name: String, email: String, add: String) {
        self.name = name
        self.email = email
        self.add = add
    }
    
    mutating func someThing() {
        name = "kajsndkjnfjk"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

