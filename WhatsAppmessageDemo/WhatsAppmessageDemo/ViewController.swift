//
//  ViewController.swift
//  WhatsAppmessageDemo
//
//  Created by mradulatray on 26/06/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        loadWhatsAppMessage()
    }
    
    func loadWhatsAppMessage() {
//            let phoneNumber = "1234567890" // Replace with the phone number
//            let message = "Hello, this is a test message." // Replace with your message
//            let urlString = "https://wa.me/\(phoneNumber)?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//
//            if let url = URL(string: urlString) {
//                let request = URLRequest(url: url)
//                webView.load(request)
//            } else {
//                // Handle invalid URL
//                let alert = UIAlertController(title: "Error", message: "Invalid URL.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
        
        
        
        
//        let phoneNumber = "1234567890" // Replace with the phone number you want to send the message to
//                let message = "Hello, this is a test message." // Replace with your message
//                let urlString = "https://wa.me/\(phoneNumber)?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//
//                if let url = URL(string: urlString) {
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    } else {
//                        // WhatsApp is not installed
//                        let alert = UIAlertController(title: "Error", message: "WhatsApp is not installed on your device.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
        
        let phoneNumber = "1234567890" // Replace with the phone number
        let message = "Hello, this is a test message." // Replace with your message
        let urlString = "https://web.whatsapp.com/send?phone=\(phoneNumber)&text=\(message)" //.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        let chromeURLString = "googlechrome://navigate?url=\(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let chromeURL = URL(string: chromeURLString) {
            if UIApplication.shared.canOpenURL(chromeURL) {
                UIApplication.shared.open(chromeURL, options: [:], completionHandler: nil)
            } else {
                // Chrome is not installed, open in Safari
                if let webURL = URL(string: urlString) {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

