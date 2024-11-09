//
//  CustomizeGameView.swift
//  QuickMaths
//
//  Created by Taylor Tran on 9/26/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Binding var isGameViewActive: Bool // Accept binding from WelcomeView
    @State private var isGameOver: Bool = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Stopwatch Animation for Timer with Neon Green Color
                ZStack {
                    // Background Circle (Static)
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 10)
                        .frame(width: 75, height: 75)
                    
                    // Animated Countdown Circle
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.timer) / CGFloat(viewModel.initialTime))
                        .stroke(Color.green, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 75, height: 75)
                        .animation(.linear(duration: 1), value: viewModel.timer)
                    
                    // Time Text
                    Text("\(viewModel.timer)")
                        .font(.custom("Courier", size: 20))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 5)
                }
                
                Spacer()
                
                // Display current question
                if let currentQuestion = viewModel.currentQuestion {
                    QuestionCard(question: currentQuestion) { answer in
                        viewModel.checkAnswer(answer)
                        viewModel.moveToNextQuestion()
                    }
                }
                
                Spacer()
                
                // End Game when time is up
                NavigationLink(
                    destination: EndScreenView(isGameViewActive: $isGameViewActive)
                        .environmentObject(viewModel),
                    isActive: $viewModel.isGameOver,
                    label: { EmptyView() }
                )
            }
            .onAppear {
                viewModel.startGame()
            }
            .navigationBarBackButtonHidden(true)
            .padding()
            .foregroundColor(.green)
        }
    }
}


struct QuestionCard: View {
    var question: Question
    var onSelectAnswer: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            // Glitchy question text
            Text(question.text)
                .font(.custom("Courier", size: 30))
                .foregroundColor(.green)
//                .shadow(color: .green, radius: 3, x: 3, y: 5)
//                .modifier(GlitchEffect())
                .padding(.bottom, 5)

            ForEach(0..<question.options.count, id: \.self) { i in
                Button(action: {
                    onSelectAnswer(i)
                }) {
                    Text("\(question.options[i])")
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.green)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        // Define a State variable for isGameViewActive
        @State var isGameViewActive = true
        
        // Provide GameView with the necessary binding and environment object
        return GameView(isGameViewActive: $isGameViewActive)
            .environmentObject(GameViewModel(difficulty: 1, questionCount: 10)) // Sample GameViewModel
            .previewLayout(.device) // Use a device layout for more realistic preview
    }
}
