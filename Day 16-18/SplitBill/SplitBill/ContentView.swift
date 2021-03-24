//
//  ContentView.swift
//  SplitBill
//
//  Created by Fadhil Hanri on 22/03/21.
//

import SwiftUI

/// Users need to be able to:
/// Enter the cost of their check,
/// Enter the number of people who shares the cost
/// Enter the amount of tip they want give
struct ContentView: View {
    @State private var checkAmount    = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage  = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) People")
                        }
                    }
                }
                
                Section {
                    Text("$\(checkAmount)")
                }
            }
            .navigationBarTitle(Text("Split Bill"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
