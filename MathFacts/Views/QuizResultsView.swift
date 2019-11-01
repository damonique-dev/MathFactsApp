//
//  QuizResultsView.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/31/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import SwiftUI

struct QuizResultsView: View {
    let quiz: Quiz
    
    private func closeQuiz() {
        
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named:"background")!)
            Color(.white).opacity(0.9).edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: { self.closeQuiz() }) {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .foregroundColor(Color.black)
                            .font(.system(size: 30))
                            .padding(.trailing, 16)
                    }
                }
                ScrollView() {
                    Section(header: QuizResultsHeaderView(quiz: quiz)) {
                        ForEach(quiz.questions) { (question) in
                            QuestionRow(question: question)
                        }
                    }
                }
            }.padding(.vertical, 44)
        }
    }
}

struct QuizResultsHeaderView: View {
    let quiz: Quiz
    
    private var correctQuestionsCount: Int {
        return quiz.questions.filter { $0.state == .right}.count
    }
    
    private var incorrectQuestionsCount: Int {
        return quiz.questions.filter { $0.state == .wrong}.count
    }
    
    private var skippedQuestionsCount: Int {
        return quiz.questions.filter { $0.state == .skipped}.count
    }
    
    var body: some View {
        VStack {
            Text("Quiz Results:")
                .foregroundColor(.black)
                .font(.custom(appFont, size: 30))
                .padding(.bottom, 16)
            VStack(alignment: .leading) {
                Text("Questions Asked: \(quiz.questions.count)")
                    .foregroundColor(.black)
                    .font(.custom(appFont, size: 24))
                HStack {
                    Text("Correct: \(correctQuestionsCount)")
                        .foregroundColor(.green)
                        .font(.custom(appFont, size: 24))
                    Spacer()
                    Text("Incorrect: \(incorrectQuestionsCount)")
                        .foregroundColor(.red)
                        .font(.custom(appFont, size: 24))
                    Spacer()
                    Text("Skipped: \(skippedQuestionsCount)")
                        .foregroundColor(.yellow)
                        .font(.custom(appFont, size: 24))
                }
            }.padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct QuestionRow: View {
    let question: Question
    
    private var questionText: String {
        return "\(question.firstNumber) \(question.operation.symbol()) \(question.secondNumber) = \(question.answer)"
    }
    
    private var userAnswer: String {
        return question.userAnswer != nil ? "\(question.userAnswer!)" : "-"
    }
    
    private var mainColor: Color {
        switch question.state {
        case .right:
            return Color.green
        case .wrong:
            return Color.red
        case .skipped:
            return Color.yellow
        default:
            return Color.black
        }
    }
    
    var body: some View {
        VStack{
            HStack {
                if question.state == .right {
                    Image(systemName: "checkmark")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .padding(.trailing, 13)
                }
                if question.state == .wrong {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding(.trailing, 13)
                }
                if question.state == .skipped {
                    Image(systemName: "forward")
                        .font(.title)
                        .foregroundColor(.yellow)
                }
                VStack(alignment: .leading) {
                    Text("\(questionText)")
                        .foregroundColor(.black)
                        .font(.custom(appFont, size: 26))
                    Text("Your Answer: \(userAnswer)")
                        .foregroundColor(mainColor)
                        .font(.custom(appFont, size: 20))
                }.padding(.leading, 24)
                Spacer()
            }
            Divider()
        }.padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}


struct QuizResultsView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultsView(quiz: Quiz(questions: [
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, userAnswer: 888, state: .right),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 88, userAnswer: 888, state: .wrong),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 88, state: .skipped),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, state: .wrong),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, userAnswer: 888, state: .skipped),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, state: .right),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, userAnswer: 888, state: .right),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 88, userAnswer: 888, state: .wrong),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 88, state: .skipped),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, state: .wrong),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, userAnswer: 888, state: .skipped),
            Question(firstNumber: 888, secondNumber: 888, operation: .add, answer: 888, state: .right),
        ], operation: .add))
    }
}
