//
//  ContentView.swift
//  Word Scramble
//
//  Created by Fadhil Hanri on 16/04/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Text("Static row 1")
            Text("Static row 2")

            ForEach(0..<5) {
                Text("Dynamic row \($0)")
            }

            Text("Static row 3")
            Text("Static row 4")
        }
        .listStyle(GroupedListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
