//
//  ContentView.swift
//  SwiftUiDemo
//
//  Created by mradulatray on 20/03/23.
//

import SwiftUI

struct ButtonAndText: View {
    
    var body: some View {
        HStack {
            Image(systemName: "globe")
                .imageScale(.small)
                .foregroundColor(.accentColor)
            Text("11.3K")
                .background(.green)
        }
    }
}

struct Cell: View {
    var body: some View {
        
        HStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.orange)
            VStack {
                HStack {
                    Text("This is the demo")
                        .background(.red)
                    Image(systemName: "globe")
                        .imageScale(.small)
                        .foregroundColor(.accentColor)
                    Text("Thisi id the title")
                    Button("...") {
                        print("three dot")
                    }
                }
                Text("Aladfnoias  oa dkfjas dk fija sdf kja skdf ijaskdf j")
                HStack {
                    ButtonAndText()
                    ButtonAndText()
                    ButtonAndText()
                    ButtonAndText()
                }
            }
            
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//                Text("Hello, world!")
//            }
            .padding()
        }
        
        
    }
}

struct tableview: View {
    var arr:[String] = []//["name","add","email","phone"]
    var body: some View {
        List {
            
            ForEach(self.arr, id: \.self) { item in
                Cell()
            }
        }
    }
}

struct ChildView: View {
    @Binding var isOn: Bool

    var body: some View {
        VStack {
            Text(isOn ? "On" : "Off")
            Button("Toggle") {
                isOn.toggle()
            }
        }
    }
}

struct ContentView: View {
    
    @State private var isOn = false

    var body: some View {
        Toggle("Toggle", isOn: $isOn)
        ChildView(isOn: $isOn)
    }
    
    
//    var body: some View {
//        tableview(arr: ["asd", "asas", "asdf", "asdfasdf","asd", "asas", "asdf", "asdfasdf"])
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
