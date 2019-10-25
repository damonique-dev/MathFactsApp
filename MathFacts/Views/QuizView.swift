//
//  ContentView.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/23/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import SwiftUI

struct QuizView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var settings: UserSettings
    
    @State var inputedAnswer: String = ""
    @State var problemState: ProblemState = .unsolved
    @State var topNumber: Int = 0
    @State var bottomNumber: Int = 0
    @State var correctAnswer: Int = 0
    @State var showSettings: Bool = false
    // To make sure the user gets unique questions for 5 questions in a row
    @State var lastFiveQuestions = [Question]()
    
    let operation: Operation

    private func generateNewProblem() {
        problemState = .unsolved
        inputedAnswer = ""
        
        switch operation {
        case .add:
            generateAdditionOrMultiplicationProblem()
            correctAnswer = topNumber + bottomNumber
        case .subtract:
            generateSubtractionProblem()
        case .multiply:
            generateAdditionOrMultiplicationProblem()
            correctAnswer = topNumber * bottomNumber
//        case .divide:
//            generateDivisionProblem()
        }
    }
    
    private func generateAdditionOrMultiplicationProblem() {
        var firstNumber = 0;
        var secondNumber = 0;
        var order = 0;
        var newQuestion: Question?
        repeat {
            firstNumber = settings.factFamilies.randomElement()!
            secondNumber = Int.random(in: 0 ... 10)
            order = Int.random(in: 0 ... 1)
            newQuestion = Question(firstNumber: order == 0 ? firstNumber : secondNumber, secondNumber: order == 0 ? secondNumber : firstNumber, operation: operation)
        } while (isRepeatedQuestion(question: newQuestion!))
        
        topNumber = order == 0 ? firstNumber : secondNumber
        bottomNumber = order == 0 ? secondNumber : firstNumber
        addToQuestionsList(question: newQuestion!)
    }
    
    private func generateSubtractionProblem() {
        var firstNumber = 0;
        var secondNumber = 0;
        var newQuestion: Question?
        repeat {
            firstNumber = settings.factFamilies.randomElement()!
            secondNumber = Int.random(in: 0 ... topNumber)
            newQuestion = Question(firstNumber: firstNumber, secondNumber: secondNumber, operation: operation)
        } while (isRepeatedQuestion(question: newQuestion!))
        
        topNumber = firstNumber
        bottomNumber = secondNumber
        correctAnswer = topNumber - bottomNumber
        addToQuestionsList(question: newQuestion!)
    }
    
    private func isRepeatedQuestion(question: Question) -> Bool {
        for previousQuestion in lastFiveQuestions {
            if previousQuestion == question {
                return true
            }
        }
        return false
    }
    
    private func addToQuestionsList(question: Question) {
        lastFiveQuestions.insert(question, at: 0)
        while lastFiveQuestions.count > 5 {
            lastFiveQuestions.removeLast()
        }
    }
    
    private func generateDivisionProblem() {
        // TODO: Need to make sure numbers generated for divide equal a whole number
    }
    
    private func answerEntered() {
        if problemState == .right {
            generateNewProblem()
        }
        if let inputedInt = Int(inputedAnswer) {
            problemState = inputedInt == correctAnswer ? .right : .wrong
        }
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named:"background")!)
            ZStack {
                Color(.white).opacity(0.9).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 30))
                            }
                        }
                        Spacer()
                        Button(action: { self.showSettings.toggle() }) {
                            HStack {
                                Image(systemName: "gear")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 30))
                            }
                        }
                    }.padding(.horizontal, 16)
                    .padding(.top, 8)
                    ProblemView(inputedAnswer: $inputedAnswer, problemState: $problemState, topNumber: topNumber, bottomNumber: bottomNumber, operation: operation)
                    Spacer()
                    NumberPadView(inputedAnswer: $inputedAnswer, problemState: $problemState) {
                        self.answerEntered()
                    }
                }.onAppear() {
                    self.generateNewProblem()
                }.sheet(isPresented: $showSettings) {
                    QuizSettingsView(onDismiss: { self.generateNewProblem() }).environmentObject(self.settings).padding(.top, 44)
                }.padding(.vertical, 40)
            }
        }
    }
}

struct ProblemView: View {
    @Binding var inputedAnswer: String
    @Binding var problemState: ProblemState
    let topNumber: Int
    let bottomNumber: Int
    let operation: Operation
    
    private let textFontSize: CGFloat = (UIScreen.main.bounds.height / 10)
    
    private var textColor: Color {
        switch problemState {
        case .right:
            return .green
        case .wrong:
            return .red
        default:
            return .black
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            VStack(alignment: .trailing, spacing: 8) {
                Text("\(topNumber)")
                    .font(.custom(appFont, size: textFontSize))
                HStack(spacing: 16) {
                    Text(operation.symbol())
                        .font(.custom(appFont, size: textFontSize))
                    Text("\(bottomNumber)")
                        .font(.custom(appFont, size: textFontSize))
                }
            }
            .padding(.trailing, 32)
            Color(.black).frame(height: 2.0)
            HStack {
                if problemState == .right {
                    HStack {
                        Text("Correct!")
                            .foregroundColor(.green)
                            .font(.custom(appFont, size: 30))
                            .padding(8)
                    }
                }
                if problemState == .wrong {
                    Text("Try Again")
                        .foregroundColor(.red)
                        .font(.custom(appFont, size: 30))
                        .padding(8)
                }
                Spacer()
                Text("\(inputedAnswer)")
                    .foregroundColor(textColor)
                    .font(.custom(appFont, size: textFontSize))
                    .padding(.trailing, 32)
            }
        }.padding(.horizontal, 16)
    }
}

struct NumberPadView: View {
    @Binding var inputedAnswer: String
    @Binding var problemState: ProblemState
    
    let enterAction: () -> ()
    
    private func addDigitToAnswer(_ digit: Int) {
        if problemState == .wrong {
            clear()
        }
        inputedAnswer += "\(digit)"
        problemState = .unsolved
    }
    
    private func clear() {
        inputedAnswer = ""
        problemState = .unsolved
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                NumberPadButton(text: "1") { self.addDigitToAnswer(1) }
                NumberPadButton(text: "2") { self.addDigitToAnswer(2) }
                NumberPadButton(text: "3") { self.addDigitToAnswer(3) }
            }
            HStack {
                NumberPadButton(text: "4") { self.addDigitToAnswer(4) }
                NumberPadButton(text: "5") { self.addDigitToAnswer(5) }
                NumberPadButton(text: "6") { self.addDigitToAnswer(6) }
            }
            HStack {
                NumberPadButton(text: "7") { self.addDigitToAnswer(7) }
                NumberPadButton(text: "8") { self.addDigitToAnswer(8) }
                NumberPadButton(text: "9") { self.addDigitToAnswer(9) }
            }
            HStack {
                NumberPadButton(text: "Clear") { self.clear() }
                NumberPadButton(text: "0") { self.addDigitToAnswer(0) }
                NumberPadButton(text: problemState == .right ? "Next" : "Enter") { self.enterAction() }
            }
        }.padding(8)
    }
}

struct NumberPadButton: View {
    let text: String
    let action: () -> ()
    
    private let width = (UIScreen.main.bounds.width / 3) - 16
    private let height = (UIScreen.main.bounds.height / 10)
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(text == "Next" ? .green : .black)
                .font(.custom(appFont, size: 30))
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
        .background(Color.white)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuizView(operation: .add)
              .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
              .previewDisplayName("iPhone SE")

           QuizView(operation: .add)
              .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
              .previewDisplayName("iPhone XS Max")
            
//            QuizView(operation: .add)
//                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
//                .previewDisplayName("iPads")
        }
    }
}
