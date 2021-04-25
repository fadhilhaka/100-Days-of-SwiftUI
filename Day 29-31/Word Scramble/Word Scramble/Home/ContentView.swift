//
//  ContentView.swift
//  Word Scramble
//
//  Created by Fadhil Hanri on 16/04/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var title = "Word Scramble"
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var isStarted = false
    @State private var countDown = 60
    
    var wordList: [String] {
        var list: [String] = []
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                list = fileContents.components(separatedBy: "\n")
            }
        }
        
        return list
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                if isStarted {
                    if countDown > 0 {
                        TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    List(usedWords, id: \.self) {
                        Image(systemName: "\($0.count).circle")
                        Text($0)
                    }
                    
                    if countDown == 0 {
                        Button("Pick New Word") {
                            countDown = 60
                            usedWords.removeAll()
                            startGame()
                        }
                        .padding()
                        
                    } else {
                        Text("\(countDown)")
                            .onReceive(timer) { time in
                                countDown -= 1
                            }
                    }
                    
                } else {
                    Button("Play") {
                        isStarted = true
                        startGame()
                    }
                }
            }
            .navigationBarTitle(title)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // exit if the remaining string is empty
        guard answer.count > 0 else { return }

        // extra validation to come
        guard isOriginal(answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard isReal(answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func isOriginal(_ answer: String) -> Bool {
        !usedWords.contains(answer)
    }
    
    func isPossible(_ answer: String) -> Bool {
        var tempWord = rootWord

        for letter in answer {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(_ answer: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: answer.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: answer, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func startGame() {
        guard isStarted else { return }
        
        rootWord = wordList.randomElement() ?? ""
        title = "Word: \(rootWord)"

        guard rootWord.isEmpty else { return }
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
