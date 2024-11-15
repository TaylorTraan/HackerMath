//
//  GameModel.swift
//  QuickMaths
//
//  Created by Taylor Tran on 9/26/24.
//

import Foundation

struct GameModel {
    private(set) var timer: Int // Timer in seconds, set dynamically
    private(set) var questions: [Question]
    private(set) var isOver: Bool = false
    private(set) var correctAnswers: Int = 0 // Track correct answers
    
    var timerValue: Int { return timer }
    
    init(timer: Int = 60, difficulty: Int = 1, questionCount: Int = 10) {
        self.timer = timer
        self.questions = GameModel.generateQuestions(difficulty: difficulty, count: questionCount)
    }
    
    // Updates the game timer each second and checks if time has run out
    mutating func updateGameStatus() {
        if timer == 0 {
            isOver = true
        } else {
            timer -= 1
        }
    }
    
    // Marks a question as correctly answered and increments score
    mutating func markCorrectAnswer() {
        correctAnswers += 1
    }
    
    // Calculate score percentage based on correct answers
    func calculateScore() -> Double {
        guard !questions.isEmpty else { return 0.0 }
        return (Double(correctAnswers) / Double(questions.count)) * 100
    }
    
    // Static function to generate questions based on difficulty level
    private static func generateQuestions(difficulty: Int, count: Int) -> [Question] {
        var questions: [Question] = []
        
        for _ in 1...count {
            let question: Question
            
            switch difficulty {
            case 1:
                question = Question.generateDifficulty1()
            case 2:
                question = Question.generateDifficulty2()
            case 3:
                question = Question.generateDifficulty3()
            case 4:
                question = Question.generateDifficulty4()
            case 5:
                question = Question.generateDifficulty5()
            default:
                question = Question.generateDifficulty1()
            }
            
            questions.append(question)
        }
        
        return questions
    }
}

struct Question {
    var text: String
    var correctAnswerIndex: Int
    var options: [Int]
    
    // Generate simple single-digit addition
    static func generateDifficulty1() -> Question {
        let operations = ["+", "-"]
        let operation = operations.randomElement()!
        
        let (text, answer): (String, Int) = {
            let a = Int.random(in: 1...9)
            let b = Int.random(in: 1...9)  // For division, we want a smaller divisor to avoid complex fractions
            switch operation {
            case "+":
                return ("\(a) + \(b)", a + b)
            case "-":
                let total = a + b  // Ensures a non-negative result for subtraction
                return ("\(total) - \(b)", a)
            default:
                return ("\(a) + \(b)", a + b) // Fallback, though this case shouldn't occur
            }
        }()
        
        return createQuestion(text: text, answer: answer)
    }
    
    // Generate double-digit or single-digit multiplication/division
    static func generateDifficulty2() -> Question {
        let operations = ["*", "/", "+", "-"]
        let operation = operations.randomElement()!
        
        let (text, answer): (String, Int) = {
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)  // For division, we want a smaller divisor to avoid complex fractions
            let c = Int.random(in: 10...99)
            switch operation {
            case "*":
                return ("\(a) x \(b)", a * b)
            case "/":
                let dividend = a * b  // Ensures clean division
                return ("\(dividend) / \(b)", a)
            case "+":
                return ("\(c) + \(a)", a + c)
            case "-":
                let total = a + c  // Ensures a non-negative result for subtraction
                return ("\(total) - \(c)", a)
            default:
                return ("\(a) + \(b)", a + b) // Fallback, though this case shouldn't occur
            }
        }()
        
        return createQuestion(text: text, answer: answer)
    }

    // Generate triple-digit addition/subtraction
    static func generateDifficulty3() -> Question {
        let operations = ["*", "/", "+", "-", "equateAddition", "equateSubtraction"]
        let operation = operations.randomElement()!
        
        let (text, answer): (String, Int) = {
            let a = Int.random(in: 10...99)
            let b = Int.random(in: 3...9)  // For division, we want a smaller divisor to avoid complex fractions
            let c = Int.random(in: 10...99)
            switch operation {
            case "*":
                return ("\(a) x \(b)", a * b)
            case "/":
                let dividend = a * b  // Ensures clean division
                return ("\(dividend) / \(b)", a)
            case "+":
                return ("\(a) + \(c)", a + c)
            case "-":
                let total = a + c  // Ensures a non-negative result for subtraction
                return ("\(total) - \(c)", a)
            case "equateAddition":
                let total = a + c
                return ("\(a) + ? = \(total)", c)
            case "equateSubtraction":
                let total = a + c
                return ("\(total) - ? = \(a)", c)
            default:
                return ("\(a) + \(b)", a + b) // Fallback, though this case shouldn't occur
            }
        }()
        
        return createQuestion(text: text, answer: answer)
    }

    // Generate intermediate fraction questions
    static func generateDifficulty4() -> Question {
        let operations = ["*", "/", "+", "-", "equateAddition", "equateSubtraction"]
        let operation = operations.randomElement()!
        
        let (text, answer): (String, Int) = {
            let a = Int.random(in: 11...99)
            let b = Int.random(in: 3...19)
            let c = Int.random(in: 100...999)
            switch operation {
            case "*":
                return ("\(a) x \(b)", a * b)
            case "/":
                let dividend = a * b  // Ensures clean division
                return ("\(dividend) / \(b)", a)
            case "+":
                return ("\(c) + \(a)", a + c)
            case "-":
                let total = a + c  // Ensures a non-negative result for subtraction
                return ("\(total) - \(c)", a)
            case "equateAddition":
                let total = a + c
                return ("\(a) + ? = \(total)", c)
            case "equateSubtraction":
                let total = a + c
                return ("\(total) - ? = \(a)", c)
            default:
                return ("\(a) + \(b)", a + b) // Fallback, though this case shouldn't occur
            }
        }()
        
        return createQuestion(text: text, answer: answer)
    }

    // Generate difficult mental math questions
    static func generateDifficulty5() -> Question {
        let operations = ["*", "/", "+", "-", "equateAddition", "equateSubtraction"]
        let operation = operations.randomElement()!
        
        let (text, answer): (String, Int) = {
            let a = Int.random(in: 11...99)
            let b = Int.random(in: 11...99)
            let c = Int.random(in: 100...999)
            switch operation {
            case "*":
                return ("\(a) x \(b)", a * b)
            case "/":
                let dividend = a * b  // Ensures clean division
                return ("\(dividend) / \(b)", a)
            case "+":
                return ("\(a) + \(c)", a + c)
            case "-":
                let total = a + c  // Ensures a non-negative result for subtraction
                return ("\(total) - \(c)", a)
            case "equateAddition":
                let total = a + c
                return ("\(a) + ? = \(total)", c)
            case "equateSubtraction":
                let total = a + c
                return ("\(total) - ? = \(a)", c)
            default:
                return ("\(a) + \(b)", a + b) // Fallback, though this case shouldn't occur
            }
        }()
        
        return createQuestion(text: text, answer: answer)
    }

    
    // Utility function to create a question with answer options
    private static func createQuestion(text: String, answer: Int) -> Question {
        var options = [answer, answer + 10]
        while options.count < 4 {
            let randomOption = Int.random(in: max(answer - 10, 0)...(answer + 10))
            if !options.contains(randomOption) {
                options.append(randomOption)
            }
        }
        options.shuffle()
        let correctAnswerIndex = options.firstIndex(of: answer) ?? 0
        return Question(text: text, correctAnswerIndex: correctAnswerIndex, options: options)
    }
}
