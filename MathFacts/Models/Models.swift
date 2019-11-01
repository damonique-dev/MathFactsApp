//
//  Models.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/23/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import Foundation

let appFont = "MarkerFelt-Thin"

enum Operation: String, Codable {
    case add
    case subtract
    case multiply
    case divide
    
    func symbol() -> String {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "x"
        case .divide:
            return "÷"
        }
    }
    
    func generateQuestion(settings: Settings) -> Question {
        switch self {
        case .add:
            return generateAdditionProblem(settings: settings)
        case .subtract:
            return generateSubtractionProblem(settings: settings)
        case .multiply:
            return generateMultiplicationProblem(settings: settings)
        case .divide:
            return generateDivisionProblem(settings: settings)
        }
    }
    
    private func generateAdditionProblem(settings: Settings) -> Question {
        var newQuestion: Question?
        repeat {
            let firstNumber = settings.getFactFamilies().randomElement()!
            let secondNumber = Int.random(in: 0 ... 10)
            let order = Int.random(in: 0 ... 1)
            newQuestion = Question(firstNumber: order == 0 ? firstNumber : secondNumber, secondNumber: order == 0 ? secondNumber : firstNumber, operation: .add, answer: firstNumber + secondNumber)
        } while (isRepeatedQuestion(question: newQuestion!, previousQuestions: settings.currentQuiz?.questions ?? []))
        
        return newQuestion!
    }
    
    private func generateSubtractionProblem(settings: Settings) -> Question {
        var newQuestion: Question?
        repeat {
            let firstNumber = settings.getFactFamilies().randomElement()!
            let secondNumber = Int.random(in: 0 ... firstNumber)
            newQuestion = Question(firstNumber: firstNumber, secondNumber: secondNumber, operation: .subtract, answer: firstNumber - secondNumber)
        } while (isRepeatedQuestion(question: newQuestion!, previousQuestions: settings.currentQuiz?.questions ?? []))

        return newQuestion!
    }
    
    private func generateMultiplicationProblem(settings: Settings) -> Question {
        var newQuestion: Question?
        repeat {
            let firstNumber = settings.getFactFamilies().randomElement()!
            let secondNumber = Int.random(in: 0 ... 10)
            let order = Int.random(in: 0 ... 1)
            newQuestion = Question(firstNumber: order == 0 ? firstNumber : secondNumber, secondNumber: order == 0 ? secondNumber : firstNumber, operation: .multiply, answer: firstNumber * secondNumber)
        } while (isRepeatedQuestion(question: newQuestion!, previousQuestions: settings.currentQuiz?.questions ?? []))
        
        return newQuestion!
    }
    
    private func generateDivisionProblem(settings: Settings) -> Question {
        var newQuestion: Question?
        repeat {
            let question = generateMultiplicationProblem(settings: settings)
            let order = Int.random(in: 0 ... 1)
            let firstNumber = question.answer
            var secondNumber = order == 0 ? question.firstNumber : question.secondNumber
            // Avoid 0/0 problem
            if firstNumber == 0 && secondNumber == 0 {
                newQuestion = nil
            } else {
                // Make sure 0 is not to divisor
                if question.firstNumber == 0 {
                    secondNumber = question.secondNumber
                } else if question.secondNumber == 0 {
                    secondNumber = question.firstNumber
                }
                newQuestion = Question(firstNumber: firstNumber, secondNumber: secondNumber, operation: .divide, answer: firstNumber / secondNumber)
            }
            
        } while (isRepeatedQuestion(question: newQuestion, previousQuestions: settings.currentQuiz?.questions ?? []))
        
        return newQuestion!
    }
    
    private func isRepeatedQuestion(question: Question?, previousQuestions: [Question]) -> Bool {
        if question == nil {
            return true
        }
        
        for previousQuestion in previousQuestions {
            if previousQuestion == question! {
                return true
            }
        }
        return false
    }
}

enum ProblemState: String, Codable {
    case unsolved
    case right
    case wrong
    case skipped
}

struct Question: Codable, Identifiable {
    let id = UUID()
    let firstNumber: Int
    let secondNumber: Int
    let operation: Operation
    let answer: Int
    var userAnswer: Int?
    var state: ProblemState = .unsolved
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.firstNumber == rhs.firstNumber
            && lhs.secondNumber == rhs.secondNumber
            && lhs.operation == rhs.operation
            && lhs.answer == rhs.answer
    }
}

struct Quiz: Codable {
    var questions: [Question]
    var operation: Operation
    var isQuizCompleted = false
}
