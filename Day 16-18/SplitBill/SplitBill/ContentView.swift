//
//  ContentView.swift
//  SplitBill
//
//  Created by Fadhil Hanri on 22/03/21.
//

import SwiftUI

/// Users need to be able to:
/// Enter the cost of their check,
/// Enter the number of people who shares the cost,
/// Enter the amount of tip they want give,
/// See the split amount,
/// See total payment
struct ContentView: View {
    @State private var checkAmount    = ""
    @State private var numberOfPeople = 0
    @State private var tipPercentage  = 0
    
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalPerPerson: Double {
        let amount = Double(checkAmount) ?? 0.0
        let peopleCount = Double(numberOfPeople + 2)
        let tipAmount = amount * Double(tipPercentages[tipPercentage])/100
        return (amount + tipAmount)/peopleCount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to give?")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(tipPercentages[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Amount per Person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
                Section(header: Text("Total Bill")) {
                    Text("$\(totalPerPerson * Double(numberOfPeople + 2), specifier: "%.2f")")
                        .foregroundColor(tipPercentage == 4 ? .red : .black)
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
