//
//  Models.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/23/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import Foundation

let appFont = "MarkerFelt-Thin"

enum Operation {
    case add
    case subtract
    case multiply
//    case divide
    // Need to make sure numbers generated for divide equal a whole number
    
    func symbol() -> String {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "x"
//        case .divide:
//            return "÷"
        }
    }
}

enum ProblemState {
    case unsolved
    case right
    case wrong
}

struct Question {
    let firstNumber: Int
    let secondNumber: Int
    let operation: Operation
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.firstNumber == rhs.firstNumber
            && lhs.secondNumber == rhs.secondNumber
            && lhs.operation == rhs.operation
    }
}
