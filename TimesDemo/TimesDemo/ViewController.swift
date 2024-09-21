//
//  ViewController.swift
//  TimesDemo
//
//  Created by mradulatray on 21/05/24.
//

import UIKit

struct Detail {
    let name: String
    let title: String
    let artist: [String]?
    
}


class SingDemo {
    
    
    static let shared = SingDemo()
    
  private init() {
      
    }
    
}

class ViewController: UIViewController {
    @IBOutlet weak var labeel1: UILabel!
    @IBOutlet weak var label2: UILabel?
    
    var artistData: [Detail] = [
    Detail(name: "aa", title: "bb", artist: ["a","v"]),
    Detail(name: "ww", title: "bb", artist: ["b","s"]),
    Detail(name: "ds", title: "bb", artist: ["f","g"]),
    Detail(name: "ff", title: "b", artist: ["r","w"]),
    Detail(name: "rr", title: "bb", artist: ["s","t"]),
    
    
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Example URL
        let urlString = "https://postoffice.hirist.tech/CL0/https:%2F%2Frecruit.hirist.tech%2Faccount-created%2F%3Fe=kaliya@yopmail.com%26k=kewk6hvvsgs5y6jjmjop/1/0101018fa3bcfb59-14784546-2f34-4722-9d2d-1dee44fcf28a-000000/8JHO59S2vi-6TASj795FbX3hxWvpUyj2owinuVMGK4Y=354"
        if let url = URL(string: urlString) {
            handleUniversalLink(url)
        }
    }
    
    
    func handleUniversalLink(_ url: URL) {
        // Step 1: Extract the nested URL part
        let urlString = url.absoluteString
        
        // Split by "/CL0/" to get the nested URL part
        let parts = urlString.split(separator: "/")
        
        // Check if there are enough parts and the nested URL is present
        guard parts.count > 2 else {
            print("Invalid URL format")
            return
        }
        
        // The nested URL part
        let nestedUrlString = String(parts[3])
        
        // Step 2: Decode the nested URL string
        if let decodedNestedUrlString = nestedUrlString.removingPercentEncoding,
           let nestedUrl = URL(string: decodedNestedUrlString) {
            
            // Step 3: Extract and print parameters from the decoded nested URL
            extractParameters(from: nestedUrl)
        } else {
            print("Failed to decode nested URL")
        }
    }

    func extractParameters(from url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems

        if let queryItems = queryItems {
            for item in queryItems {
                print("\(item.name) = \(item.value ?? "")")
            }
            
            // Example: Extract specific parameters
            if let email = queryItems.first(where: { $0.name == "e" })?.value {
                print("Email: \(email)")
            }
            if let key = queryItems.first(where: { $0.name == "k" })?.value {
                print("Key: \(key)")
            }
        } else {
            print("No query items found")
        }
    }

    
    
    
}

