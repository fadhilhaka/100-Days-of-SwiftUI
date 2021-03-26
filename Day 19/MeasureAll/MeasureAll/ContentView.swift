//
//  ContentView.swift
//  MeasureAll
//
//  Created by Fadhil Hanri on 26/03/21.
//

import SwiftUI

enum Temperature: String, CaseIterable {
    case celcius, fahrenheit, kelvin
    
    static func getType(by index: Int) -> Temperature {
        Temperature.allCases[index]
    }
}

struct ContentView: View {
    @State private var selection: Int = 0
    @State private var selectionFrom: Int = 0
    @State private var selectionTo: Int = 0
    @State private var convertFrom: String = ""
    @State private var convertTo: Double = 0.0
    @State private var normalizeValue: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Conversion type", selection: $selection) {
                    ForEach(0 ..< Temperature.allCases.count) {
                        Text("\(Temperature.allCases[$0].rawValue)")
                    }
                }
                .padding()
                
                Section {
                    TextField("Input number to convert \(convertFrom)", text: $convertFrom)
                        .keyboardType(.decimalPad)
                        .onChange(of: convertFrom) { value in
                            calculateConvertion(from: selectionFrom, to: selectionTo)
                        }
                    
                    Picker("Conversion type", selection: $selectionFrom) {
                        ForEach(0 ..< Temperature.allCases.count) {
                            Text("\(Temperature.allCases[$0].rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectionFrom) { index in
                        calculateConvertion(from: selectionFrom, to: selectionTo)
                    }
                }
                
                Section {
                    Text("Converted to \(convertTo, specifier: "%.2f")")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

                    Picker("Conversion type", selection: $selectionTo) {
                        ForEach(0 ..< Temperature.allCases.count) {
                            Text("\(Temperature.allCases[$0].rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectionTo) { _ in
                        calculateConvertion(from: selectionFrom, to: selectionTo)
                    }
                }
            }
            .navigationBarTitle(Text("Temperature Conversion"), displayMode: .inline)
        }
    }
    
    func calculateConvertion(from selectedIndex: Int, to targetedIndex: Int) {
        let type       = Temperature.getType(by: selectedIndex)
        let targetType = Temperature.getType(by: targetedIndex)
        var normalizeValue: Double = 0.0
        
        switch type {
        case .celcius:
            normalizeValue = Double(convertFrom) ?? 0.0
        case .fahrenheit, .kelvin:
            normalizeValue = normalize(type, value: convertFrom)
        }
        
        convertTo = targetType == .celcius ? normalizeValue : convert(normalizeValue, to: targetType)
    }
    
    func normalize(_ type: Temperature, value: String) -> Double {
        guard let value = Double(value) else { return 0.0 }
        
        switch type {
        case .celcius:
            return value
        case .fahrenheit:
            return (value - 32.0) * 5/9
        case .kelvin:
            return value - 273.15
        }
    }
    
    func convert(_ value: Double, to type: Temperature) -> Double {
        switch type {
        case .celcius:
            return value
        case .fahrenheit:
            return (value * 9/5) + 32.0
        case .kelvin:
            return value + 273.15
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
