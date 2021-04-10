//
//  ContentView.swift
//  Better Rest
//
//  Created by Fadhil Hanri on 10/04/21.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%.4g") hours")
                    }
                }
                
                Section {
                    DatePicker("Please enter a date:", selection: $wakeUp, in: Date()... , displayedComponents: .date)
                }
            }
            .navigationTitle("Better Rest")
        }
    }
    
    func createDate() {
//        var components = DateComponents()
//            components.hour = 8
//            components.minute = 0
//        let date = Calendar.current.date(from: components) ?? Date()
        let component = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hour = component.hour ?? 0
        let minute = component.minute ?? 0
        
        let formatter = DateFormatter()
            formatter.timeStyle = .short
//            formatter.dateStyle = .short
        let dateString = formatter.string(from: Date())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
