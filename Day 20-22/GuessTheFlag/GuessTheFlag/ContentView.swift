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

struct InfoText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .light))
            .padding()
    }
}

extension Text {
    func EssentialText() -> some View {
        self
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.black)
    }
}

extension Image {
    func FlagImage() -> some View {
        self
            .renderingMode(.original)
            .shadow(radius: 3.0)
            .padding()
    }
}

struct ContentView: View {
    @State private var score = 0
    @State private var scoreTitle: Answer = .Wrong
    @State private var showingScore = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var totalQuestion = 0
    @State private var previousCountry = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
    
            VStack {
                Text("Pick the correct flag for this country:")
                    .modifier(InfoText())
                
                Text(countries[correctAnswer])
                    .EssentialText()
                
                ForEach(0 ..< 3) { index in
                    Button(action: {
                        print("\(countries[index]) is tapped")
                        checkAnswer(with: index)
                        
                    }) {
                        Image(self.countries[index])
                            .FlagImage()
                    }
                    .alert(isPresented: $showingScore) {
                        let buttonTitle = totalQuestion == 10 ? "Start Again" : "Next"
                        let message = createMessage()
                        
                        return Alert(title: Text(scoreTitle.rawValue), message: Text(message), dismissButton: .default(Text(buttonTitle)) {
                            if totalQuestion == 10 {
                                self.reset()
                            }
                            
                            self.prepareQuestion()
                        })
                    }
                }
                
                Spacer()

                Text("Current score:")
                    .modifier(InfoText())
                
                Text("\(score)")
                    .EssentialText()
                
                Spacer()
            }
        }
    }
    
    func checkAnswer(with index: Int) {
        totalQuestion  += 1
        score          += index == correctAnswer ? 10 : -10
        scoreTitle      = index == correctAnswer ? .Correct : .Wrong
        showingScore    = true
        previousCountry = countries[correctAnswer]
    }
    
    func createMessage() -> String  {
        let scoreMessage  = totalQuestion == 10 ? "Your final score is: \(score)" : "Your score is: \(score)"
        return scoreTitle == .Correct ? score == 100 ? "Congratulations!\nYou have a PERFECT SCORE!!\n\(scoreMessage)" : "Congratulations!\n\(scoreMessage)" : "What a pity, it's \(countries[correctAnswer]) flag.\n\(scoreMessage)"
    }
    
    func prepareQuestion() {
        countries.shuffle()
        
        while previousCountry == countries[correctAnswer] {
            correctAnswer = Int.random(in: 0...2)
        }
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
