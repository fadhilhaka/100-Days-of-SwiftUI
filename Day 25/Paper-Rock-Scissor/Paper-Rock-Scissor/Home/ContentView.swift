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
    @State var showingResult = false
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
                    .alert(isPresented: $showingResult) {
                        Alert(title: Text("Alert"), message: Text("ok"), dismissButton: .default(Text("Play Again")))
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
    @State var totalRound = 1
    @State var resultMessage = "Pick your weapon..."
    
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
        Computer(weapon: computerWeapon, isPrepared: computerIsPrepared)
        
        Spacer()
        
        Text(resultMessage)
            .font(.title)
        
        Spacer()
        
        Player(weapon: playerWeapon, score: score, isPrepared: playerIsPrepared) { weapon in
            playerAction(weapon)
        }

//        if showAlert {
//            Alert(title: "Alert", message: "ok", dismissButton: .default(Text("Play Again")))
//        }
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
//        case paper = "🖐🏼"
//        case rock = "✊🏼"
//        case scissor = "✌🏼"
        var playerWin = false
        
        switch playerWeapon {
        case .paper:
            switch computerWeapon {
            case .paper:
                resultMessage = "It's a Draw."
            case .rock:
                resultMessage = "You Win!!!"
            case .scissor:
                resultMessage = "You Lose..."
            }
        case .rock:
            switch computerWeapon {
            case .paper:
                resultMessage = "You Lose..."
            case .rock:
                resultMessage = "It's a Draw."
            case .scissor:
                resultMessage = "You Win!!!"
            }
        case .scissor:
            switch computerWeapon {
            case .paper:
                resultMessage = "You Win!!!"
            case .rock:
                resultMessage = "You Lose..."
            case .scissor:
                resultMessage = "It's a Draw."
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
