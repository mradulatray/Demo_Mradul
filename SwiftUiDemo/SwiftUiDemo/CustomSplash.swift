//
//  CustomSplash.swift
//  SwiftUiDemo
//
//  Created by mradulatray on 22/03/23.
//

import SwiftUI

struct Person {
    @State var name: String
    var email: String
    var add: String
    
    internal init(name: String, email: String, add: String) {
        self.name = name
        self.email = email
        self.add = add
    }
    
    mutating func addName() {
        name = "kjanskjdnfjk"
    }
    
}

struct CustomSplash: View {
    @State var isActivate: Bool = false
    var body: some View {
        
        if isActivate{
            ContentView()
        } else {
            VStack {
                Image("demo")
                  .resizable()
                    .foregroundColor(.orange)
                    .font(.system(size: 30))
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isActivate = true
                }
            }
        }
        
        
    }
}

struct CustomSplash_Previews: PreviewProvider {
    static var previews: some View {
        CustomSplash()
    }
}
