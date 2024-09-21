//
//  ViewController.swift
//  DemoDeepLInking
//
//  Created by mradulatray on 06/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = self.view.center
        button.setTitle("deep link", for: .normal)

//        button.addTarget(self, action: #selector(buttonTapped()), for: .touchUpInside)
        button.backgroundColor = .orange

        button.addTarget(self, action: #selector(buttonTappedff(_ :)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    @objc func buttonTappedff(_ sender: UIButton) {
        print("some thisn")
        guard let url = URL(string:
//        "https://beta-iim_recruiter/reset-password?email=kumar.shubham@naukri.com&key=N2VhODE4MWZkNzJiNWQwZTRhMjgyNDJiZjg1YjVhNzVjYzE1ZDcwNzRiODIzNjZhOTE1YmI2NDExOWFlYzg1Zg=="
        "iim_recruiter") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    
    }


}

