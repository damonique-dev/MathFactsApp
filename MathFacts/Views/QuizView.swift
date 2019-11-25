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
    @EnvironmentObject var userSettings: UserSettings
    
    @State var inputedAnswer: String = ""
    @State var problemState: ProblemState = .unsolved
    @State var topNumber: Int = 0
    @State var bottomNumber: Int = 0
    @State var correctAnswer: Int = 0
    @State var showSettings: Bool = false
    @State var currentQuestion: Question?
    @State var showResults = false
    @State var showModal = false
    
    let operation: Operation
    
    private func startNewOrResumeQuiz() {
        if userSettings.currentQuiz.isQuizCompleted ||  userSettings.currentQuiz.operation != operation {
            userSettings.currentQuiz = Quiz(questions: [Question](), operation: operation)
        }
        
        generateNewProblem()
    }

    private func generateNewProblem() {
        problemState = .unsolved
        inputedAnswer = ""
        currentQuestion = operation.generateQuestion(settings: userSettings.settings)
        topNumber = currentQuestion!.firstNumber
        bottomNumber = currentQuestion!.secondNumber
        correctAnswer = currentQuestion!.answer
        
        userSettings.currentQuiz.questions.append(currentQuestion!)
    }
    
    private func answerEntered() {
        if problemState != .unsolved {
            generateNewProblem()
        }
        if inputedAnswer.isEmpty {
            var question = currentQuestion!
            question.state = .skipped
            userSettings.currentQuiz.questions.removeLast()
            userSettings.currentQuiz.questions.append(question)
        }
        if let inputedInt = Int(inputedAnswer) {
            problemState = inputedInt == correctAnswer ? .right : .wrong
            var question = currentQuestion!
            question.state = problemState
            question.userAnswer = inputedInt
            
            userSettings.currentQuiz.questions.removeLast()
            userSettings.currentQuiz.questions.append(question)
        }
        
        if userSettings.currentQuiz.questions.count == userSettings.numberOfQuestionInQuiz {
            userSettings.currentQuiz.completionDate = Date()
            userSettings.currentQuiz.isQuizCompleted = true
            userSettings.settings.pastQuizzes.append(userSettings.currentQuiz)
            AppAnalytics.logQuizCompetionEvent(quiz: userSettings.currentQuiz, factFamily: userSettings.settings.getFactFamilies())
            showModal = true
            showResults = true
        } else {
            generateNewProblem()
        }
    }
    
    private func dismissModal() {
        if showResults {
            presentationMode.wrappedValue.dismiss()
        }
        if showSettings {
            generateNewProblem()
        }
        showSettings = false
        showResults = false
        showModal = false
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
                        Button(action: {
                            self.showSettings.toggle()
                            self.showModal.toggle()
                        }) {
                            HStack {
                                Image(systemName: "gear")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 30))
                            }
                        }
                    }.padding(.horizontal, 16)
                    .padding(.top, 8)
                    QuizOverview(quiz: $userSettings.currentQuiz)
                    ProblemView(inputedAnswer: $inputedAnswer, problemState: $problemState, topNumber: topNumber, bottomNumber: bottomNumber, operation: operation)
                    Spacer()
                    NumberPadView(inputedAnswer: $inputedAnswer, problemState: $problemState) {
                        self.answerEntered()
                    }
                }.onAppear() {
                    self.startNewOrResumeQuiz()
                }.padding(.vertical, 40)
            }
        }.sheet(isPresented: $showModal, onDismiss: { self.dismissModal() }) {
            if self.showSettings {
                QuizSettingsView(onDismiss: {
                    self.dismissModal()
                }).environmentObject(self.userSettings).padding(.top, 60)
            }
            if self.showResults {
                QuizResultsView(quiz: self.userSettings.currentQuiz, onDismiss: { self.dismissModal() })
            }
        }
    }
}

struct QuizOverview: View {
    @Binding var quiz: Quiz
    
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
        HStack {
            Text("Question \(quiz.questions.count)")
                .foregroundColor(.black)
                .font(.custom(appFont, size: 18))
            Text("Correct: \(correctQuestionsCount)")
                .foregroundColor(.green)
                .font(.custom(appFont, size: 18))
            Text("Incorrect: \(incorrectQuestionsCount)")
                .foregroundColor(.red)
                .font(.custom(appFont, size: 18))
            Text("Skipped: \(skippedQuestionsCount)")
                .foregroundColor(.yellow)
                .font(.custom(appFont, size: 18))
        }.padding(.vertical, 8)
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
                        .foregroundColor(.black)
                    Text("\(bottomNumber)")
                        .font(.custom(appFont, size: textFontSize))
                        .foregroundColor(.black)
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
                NumberPadButton(text: inputedAnswer.isEmpty ? "Skip": (problemState == .right ? "Next" : "Enter")) { self.enterAction() }
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
                .foregroundColor(text == "Next" ? .green : ( text == "Skip" ? .yellow : .black))
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
