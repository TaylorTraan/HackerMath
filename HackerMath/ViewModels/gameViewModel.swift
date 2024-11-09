//
//  gameViewModel.swift
//  QuickMaths
//
//  Created by Taylor Tran on 9/26/24.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var gameModel: GameModel
    @Published var timer: Int
    @Published var currentQuestionIndex = 0
    @Published var isGameOver = false
    var initialTime: Int

    var allQuestions: [Question] { gameModel.questions }
    var correctAnswers: Int { gameModel.correctAnswers }
    var score: Double { gameModel.calculateScore() }

    var currentQuestion: Question? {
        guard currentQuestionIndex < allQuestions.count else { return nil }
        return allQuestions[currentQuestionIndex]
    }

    init(timer: Int = 60, difficulty: Int, questionCount: Int) {
        self.timer = timer
        self.initialTime = timer
        gameModel = GameModel(timer: timer, difficulty: difficulty, questionCount: questionCount)
    }

    func startGame() {
        startTimer()
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }

    private func updateTime() {
        if timer > 0 {
            timer -= 1
        } else {
            isGameOver = true
        }
    }

    func checkAnswer(_ answer: Int) {
        if let question = currentQuestion, question.options[answer] == question.options[question.correctAnswerIndex] {
            gameModel.markCorrectAnswer()
        }
    }

    func moveToNextQuestion() {
        if currentQuestionIndex < allQuestions.count - 1 {
            currentQuestionIndex += 1
        } else {
            isGameOver = true
        }
    }
}
