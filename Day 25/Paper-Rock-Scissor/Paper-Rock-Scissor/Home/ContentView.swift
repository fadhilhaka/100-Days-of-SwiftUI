//
//  ContentView.swift
//  Paper-Rock-Scissor
//
//  Created by Fadhil Hanri on 02/04/21.
//

import SwiftUI

enum Weapon: String, CaseIterable {
    case paper = "🖐🏼"
    case rock = "✊🏼"
    case scissor = "✌🏼"
}

struct Computer: View {
    let weapon: Weapon
    let isPrepared: Bool
    
    var body: some View {
        let weaponText  = Text(weapon.rawValue).font(.system(size: 120)).rotationEffect(Angle(degrees: 180.0))
        let prepareText = Text("is preparing...").font(.system(size: 24, weight: .light))
        
        Text("Computer")
            .font(.largeTitle)
            .padding()
        
        if isPrepared {
            prepareText.hidden()
        } else {
            prepareText
        }
        
        Spacer()
        
        if isPrepared {
            weaponText
        } else {
            weaponText.hidden()
        }
    }
}

struct Player: View {
    let weapon: Weapon
    let score: Int
    let isPrepared: Bool
    let action: (String) -> (Void)
    
    var body: some View {
        let weaponText = Text(weapon.rawValue).font(.system(size: 120))
        let weaponList = Weapon.allCases
        
        if isPrepared {
            weaponText
        } else {
            weaponText.hidden()
            
            HStack {
                ForEach(weaponList, id: \.self) {
                    let weaponName = $0.rawValue
                    
                    Button {
                        action(weaponName)
                    } label: {
                        Text(weaponName).font(.system(size: 90))
                    }
                }
            }
        }
        
        Spacer()
        Text("Player")
            .font(.largeTitle)
            .padding()
        Text("Score: \(score)")
            .font(.system(size: 24, weight: .light))
    }
}

struct ContentView: View {
    @State var computerSelection = Int.random(in: 0 ... 2)
    @State var computerIsPrepared = false
    @State var playerSelection = 0
    @State var playerIsPrepared = false
    @State var score = 0
    @State var totalRound = 0
    @State var resultMessage = "Pick your weapon..."
    @State var showingResult = false
    @State var showingFinalResult = false
    
    let weaponList = Weapon.allCases
    
    var computerWeapon: Weapon {
        get { weaponList[computerSelection] }
    }
    
    var playerWeapon: Weapon {
        get { weaponList[playerSelection] }
    }
    
    var showAlert: Bool {
        get { computerIsPrepared && playerIsPrepared }
    }
    
    var body: some View {
        let resultText = Text(resultMessage).font(.title)
        let resetButton = Button("Play Again") {
            computerIsPrepared = false
            playerIsPrepared   = false
            resultMessage = "Pick your weapon..."
            showingResult = false
        }
        
        VStack {
            Computer(weapon: computerWeapon, isPrepared: computerIsPrepared)
            
            Spacer()
            
            if showingResult {
                resultText
                resetButton
            } else {
                resultText
            }
            
            Spacer()
            
            Player(weapon: playerWeapon, score: score, isPrepared: playerIsPrepared) { weapon in
                playerAction(weapon)
            }
        }
        .alert(isPresented: $showingFinalResult) {
            Alert(title: Text("Final Score"), message: Text("Your final score is: \(score)"), dismissButton: .default(Text("Restart Challenge")) {
                computerIsPrepared = false
                playerIsPrepared   = false
                resultMessage = "Pick your weapon..."
                showingResult = false
                score         = 0
                totalRound    = 0
            })
        }
    }
    
    func playerAction(_ weapon: String) {
        computerSelection  = Int.random(in: 0...2)
        computerIsPrepared = true
        playerSelection    = weaponList.firstIndex(where: { $0.rawValue == weapon }) ?? 0
        playerIsPrepared   = true
        setMessage()
        print("action success: \(weapon), player selection: \(playerSelection)")
    }
    
    func setMessage() {
//        case paper = "🖐🏼" 1-2-0
//        case rock = "✊🏼" 0-1-2
//        case scissor = "✌🏼" 2-0-1
//        0>1>2>0
        switch playerWeapon {
        case .paper:
            switch computerWeapon {
            case .paper:
                resultMessage = "It's a Draw."
                score += 1
            case .rock:
                resultMessage = "You Win!!!"
                score += 3
            case .scissor:
                resultMessage = "You Lose..."
            }
        case .rock:
            switch computerWeapon {
            case .paper:
                resultMessage = "You Lose..."
            case .rock:
                resultMessage = "It's a Draw."
                score += 1
            case .scissor:
                resultMessage = "You Win!!!"
                score += 3
            }
        case .scissor:
            switch computerWeapon {
            case .paper:
                resultMessage = "You Win!!!"
                score += 3
            case .rock:
                resultMessage = "You Lose..."
            case .scissor:
                resultMessage = "It's a Draw."
                score += 1
            }
        }
        
        totalRound += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showingResult = totalRound != 10
            showingFinalResult = totalRound == 10
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
