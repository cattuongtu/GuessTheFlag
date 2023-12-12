//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cat-Tuong Tu on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var gameFinished = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    
    // State to keep track of rotating icon
    @State private var isRotated = [false, false, false]
    
    @State private var opacity = 1.0
    @State private var scale = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            self.isRotated[number].toggle()
                            withAnimation {
                                opacity -= 0.75
                                scale -= 0.5
                            }
                        
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                        .rotationEffect(Angle.degrees(isRotated[number] ? 360 : 0))
                        .opacity(!isRotated[number] ? opacity : 1.0)
                        .scaleEffect(!isRotated[number] ? scale : 1.0)
                        .animation(_:.easeOut)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert("Your final score is \(score)", isPresented: $gameFinished) {
            Button("Play Again", action: reset)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
    }
        
    
    func flagTapped(_ number : Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])!"
            score -= 1
        }
        
        questionCount += 1
        showingScore = true
        if questionCount == 8 {
            gameFinished = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacity = 1.0
        scale = 1.0
        isRotated = [false, false, false]
    }
    
    func reset() {
        score = 0
        questionCount = 0
        gameFinished = false
        showingScore = false
        opacity = 1.0
        scale = 1.0
        isRotated = [false, false, false]
    }
}

#Preview {
    ContentView()
}
