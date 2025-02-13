//
//  ViewController.swift
//  Housing.comDemo
//
//  Created by mradulatray on 24/09/24.
//

import UIKit

struct Daata: Decodable {
    var name: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       print([1,2,3,4,5,6,7].customReduce(initialValue: 0) { oldValue, value in
            return oldValue+value
        })
        guard let url = URL(string: "google.com") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                if let data {
                    do {
                        let parseData = try JSONDecoder().decode(Daata.self, from: data)
                    } catch {
                        print("some error occour")
                    }
                }
                
            }
        }
        
        
        
    }
}

extension Array {
    
    func customReduce<T>(initialValue: T, com: (T,T) -> T) -> T {
        var result: T = initialValue
        for val in self {
            result = com(result, val as! T)
        }
        return result
    }
}

