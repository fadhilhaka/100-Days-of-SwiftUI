//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fadhil Hanri on 29/03/21.
//

import SwiftUI

enum Answer: String {
    case Correct, Wrong
}

struct ContentView: View {
    @State private var score = 0
    @State private var scoreTitle: Answer = .Wrong
    @State private var showingScore = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var totalQuestion = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
    
            VStack {
                Text("Pick the correct flag for this country:")
                    .foregroundColor(.white)
                    .padding()
                
                Text(countries[correctAnswer])
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                Text("Current score: \(score)")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .light))
                
                ForEach(0 ..< 3) { index in
                    Button(action: {
                        print("\(countries[index]) is tapped")
                        checkAnswer(with: index)
                        
                    }) {
                        Image(self.countries[index])
                            .renderingMode(.original)
                            .shadow(radius: 3.0)
                            .padding()
                    }
                    .alert(isPresented: $showingScore) {
                        let buttonTitle = totalQuestion == 10 ? "Start Again" : "Next"
                        let scoreMessage = totalQuestion == 10 ? "Your final score is: \(score)" : "Your score is: \(score)"
                        let message = scoreTitle == .Correct ? "Congratulations!\n\(scoreMessage)" : "What a pity, it's \(countries[correctAnswer]) flag.\n\(scoreMessage)"
                        
                        return Alert(title: Text(scoreTitle.rawValue), message: Text(message), dismissButton: .default(Text(buttonTitle)) {
                            if totalQuestion == 10 {
                                self.reset()
                            }
                            
                            self.prepareQuestion()
                        })
                    }
                }
                
                Spacer()
            }
        }
    }
    
    func checkAnswer(with index: Int) {
        score     += index == correctAnswer ? 10 : -10
        scoreTitle = index == correctAnswer ? .Correct : .Wrong
        showingScore = true
        totalQuestion += 1
    }
    
    func prepareQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        score = 0
        totalQuestion = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
