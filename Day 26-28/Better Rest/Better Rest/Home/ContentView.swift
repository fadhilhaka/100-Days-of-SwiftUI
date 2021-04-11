//
//  ContentView.swift
//  Better Rest
//
//  Created by Fadhil Hanri on 10/04/21.
//

import SwiftUI
import CoreML

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
            components.hour = 7
            components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    let model: SleepCalculator = {
        do {
            let config = MLModelConfiguration()
            return try SleepCalculator(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create SleepCalculator")
        }
    }()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0.0) {
                Form {
                    Section {
                        Text("When do you want to wake up?")
                            .frame(maxWidth: .infinity, idealHeight: 20.0, maxHeight: 20.0, alignment: Alignment(horizontal: .leading, vertical: .center))
                        DatePicker("When do you want to wake up?", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, idealHeight: 20.0, maxHeight: 20.0, alignment: Alignment(horizontal: .center, vertical: .center))
                    }
                    
                    Section {
                        Text("Desired amount of sleep:")
                            .frame(maxWidth: .infinity, idealHeight: 20.0, maxHeight: 20.0, alignment: Alignment(horizontal: .leading, vertical: .center))
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25, onEditingChanged: { _ in
                            calculateBedtime()
                        }) {
                            let hours = Int(sleepAmount)
                            let decimalHour = sleepAmount.truncatingRemainder(dividingBy: 1)
                            let minutes = decimalHour * 60.0
                            
                            if minutes > 0 {
                                Text("\(hours) hours \(minutes, specifier: "%.2g") minutes")
                            } else {
                                Text("\(hours) hours")
                            }
                        }
                    }
                    
                    Section {
                        Text("Daily coffee intake:")
                            .frame(maxWidth: .infinity, idealHeight: 20.0, maxHeight: 20.0, alignment: Alignment(horizontal: .leading, vertical: .center))
                        Stepper(value: $coffeeAmount, in: 1...20, onEditingChanged: { _ in
                            calculateBedtime()
                        }) {
                            Text("\(coffeeAmount) \(coffeeAmount > 1 ? "cups" : "cup")")
                        }
                    }
                    
//                    Button("What time should I sleep?") {
//                        calculateBedtime()
//                    }
//                    .frame(maxWidth: .infinity, idealHeight: 20.0, maxHeight: 20.0, alignment: Alignment(horizontal: .center, vertical: .center))
                    
                    VStack {
                        if !alertMessage.isEmpty {
                            Spacer()
                            Text("Bed time:")
                            Spacer()
                            Text(alertTitle)
                                .font(.system(size: 48.0, weight: .black, design: .default))
                            Spacer()
                            Text(alertMessage)
                                .font(.system(size: 12.0, weight: .light, design: .default))
                        } else {
                            Text("This app will help you calculate your bed time, based on the amount of coffe you drank.")
                                .font(.system(size: 12.0, weight: .light, design: .default))
                        }
                    }
                }
            }
            .navigationTitle("Better Rest")
            
//            .navigationBarItems(trailing: Button(action: calculateBedtime) {
//                Text("Calculate")
//            })
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
//            }
        }
    }
    
    func calculateBedtime() {
        let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hourToSecond = (component.hour ?? 0) * 60 * 60
        let minuteToSecond = (component.minute ?? 0) * 60
        let wakeUpInSecond = Double(hourToSecond + minuteToSecond)
        
        do {
            let prediction = try model.prediction(input: SleepCalculatorInput(wake: wakeUpInSecond, estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
                formatter.timeStyle = .short
            
            let actualHoursSleep = (prediction.actualSleep / (60.0*60.0))
            let actualMinutesSleep = actualHoursSleep.truncatingRemainder(dividingBy: 1) * 60.0
            let coffeMessage = coffeeAmount > 1 ? "\(coffeeAmount) cups" : "\(coffeeAmount) cup"
            var sleepMessage = actualHoursSleep < 2.0 ? "\(Int(actualHoursSleep)) hour" : "\(Int(actualHoursSleep)) hours"
                sleepMessage += Int(actualMinutesSleep) > 0 ? Int(actualMinutesSleep) > 1 ?
                    " \(Int(actualMinutesSleep)) minutes" : " \(Int(actualMinutesSleep)) minute" : ""
            
            alertTitle = "\(formatter.string(from: sleepTime))"
            alertMessage = "Based on \(coffeMessage) of coffe you drank today, your actual sleep time is \(sleepMessage)."
            
        } catch {
            print("Error feeding data at: \(#function)")
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
//        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
