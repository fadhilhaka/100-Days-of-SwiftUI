//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Fadhil Hanri on 31/03/21.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.largeTitle.weight(.bold))
            .foregroundColor(.primary)
    }
}

struct ContentView: View {
    var hogwartsHouses = ["Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin"]
    
    var body: some View {
        Text("Hogwarts Houses")
            .modifier(Title())
            .padding()
        
        GridStack(rows: 1, columns: 4) { row, col in
            VStack {
                Text(hogwartsHouses[col])
                Image(systemName: "\(row * 4 + col + 1).circle")
            }
        }
        
        HStack {
            Text("Gryffindor")
                .font(.title)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.footnote)
        
        HStack {
            Text("Gryffindor")
                .blur(radius: 0)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .blur(radius: 5)
        
        Text("Hello, world!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .padding()
        
        Button("Hello World") {
            print(type(of: self.body))
        }
        .frame(width: 120, height: 40)
        .background(Color.red)
        
        Text("Hello World")
            .padding()
            .background(Color.red)
            .padding()
            .background(Color.blue)
            .padding()
            .background(Color.green)
            .padding()
            .background(Color.yellow)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
