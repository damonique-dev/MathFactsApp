//
//  QuizHistoryView.swift
//  MathFacts
//
//  Created by Damonique Blake on 11/24/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import SwiftUI

struct QuizHistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSettings: UserSettings
    
    private var quizzes: [Quiz] {
        return userSettings.settings.pastQuizzes
    }
    
    var btnBack : some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color.black)
                    .font(.system(size: 30))
            }
        }
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named:"background")!)
            Color(.white).opacity(0.9).edgesIgnoringSafeArea(.all)
            ScrollView() {
                Section(header:
                    Text("Quiz History")
                        .foregroundColor(.black)
                        .font(.custom(appFont, size: 36))
                ) {
                    ForEach(quizzes) { (quiz) in
                        NavigationLink(destination: QuizResultsScrollView(quiz: quiz)) {
                            QuizHistoryRow(quiz: quiz)
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct QuizHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        QuizHistoryView()
    }
}

struct QuizHistoryRow: View {
    let quiz: Quiz
    
    private var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy"
        return dateFormatter.string(from: quiz.completionDate!)
    }
    
    private var numOfQuestions: Int {
        return quiz.questions.count
    }
    
    private var numCorrect: Int {
        return quiz.questions.filter { $0.state == .right }.count
    }
    
    private var scoreString: String {
        return "\(numCorrect) Correct out of \(numOfQuestions)"
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(quiz.operation.toString())
                        .foregroundColor(.black)
                        .font(.custom(appFont, size: 24))
                    Text(dateString)
                        .foregroundColor(.black)
                        .font(.custom(appFont, size: 18))
                }
                Spacer()
                HStack(spacing: 16.0) {
                    VStack(alignment: .trailing) {
                        Text(scoreString)
                            .foregroundColor(.black)
                            .font(.custom(appFont, size: 20))
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.black)
                }
            }.padding()
            Divider()
        }
    }
}
