//
//  EndScreenView.swift
//  QuickMaths
//
//  Created by Taylor Tran on 11/7/24.
//

import Foundation
import SwiftUI

struct EndScreenView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Binding var isGameViewActive: Bool // Binding to control navigation back to WelcomeView

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                // "Game Over" Title with Neon Effect
                Text("GAME OVER")
                    .font(.custom("Courier", size: 40))
                    .foregroundColor(.green)
                    .shadow(color: .green, radius: 10)
                    .padding(.bottom, 20)
                
                // Correct Answers Display
                Text("Correct Answers: \(viewModel.correctAnswers) / \(viewModel.allQuestions.count)")
                    .font(.custom("Courier", size: 20))
                    .foregroundColor(.green)
                    .padding(.bottom, 10)
                
                // Score Display
                Text("Score: \(viewModel.score, specifier: "%.2f")%")
                    .font(.custom("Courier", size: 20))
                    .foregroundColor(.green)
                    .padding(.bottom, 30)
                
                // Return to Home Button
                Button(action: {
                    isGameViewActive = false // Set isGameViewActive to false to prevent returning to GameView
                }) {
                    Text("Return to Home")
                        .font(.custom("Courier", size: 18))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 1))
                }
                .padding(.horizontal, 50)
                
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 2))
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct EndScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Define a State variable for the isGameViewActive binding
        @State var isGameViewActive = true
        
        NavigationView {
            EndScreenView(isGameViewActive: $isGameViewActive) // Provide the binding
                .environmentObject(GameViewModel(difficulty: 1, questionCount: 10)) // Example GameViewModel for preview
        }
        .previewDisplayName("End Screen Preview")
        .background(Color.black)
    }
}
