//
//  QuizSettingsView.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/24/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import SwiftUI

struct QuizSettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var settings: UserSettings
    
    let onDismiss: () -> ()
    private let width = (UIScreen.main.bounds.width / 3) - 16
    private let height = (UIScreen.main.bounds.height / 15)
    
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
            
            ZStack {
                Color(.white).opacity(0.9).edgesIgnoringSafeArea(.all)
                VStack(spacing: 8) {
                    Text("Quiz Settings")
                        .foregroundColor(.black)
                        .font(.custom(appFont, size: 35))
                    FactFamilySelector()
                    NumberOfQuestionsSelector().environmentObject(settings)
                    
                    HStack {
                        Button(action: { self.settings.resetFactFamilies() }) {
                            Text("Reset")
                                .foregroundColor(.black)
                                .font(.custom(appFont, size: 30))
                        }
                        .frame(width: width, height: height)
                        .background(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 2))
                        
                        Button(action: {
                            self.onDismiss()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Close")
                                .foregroundColor(.black)
                                .font(.custom(appFont, size: 30))
                        }
                        .frame(width: width, height: height)
                        .background(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 2))
                        .background(Color.yellow)
                        
                    }.padding(.top, 16)
                    Spacer()
                }.padding(.top, 24)
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct FactFamilySelector: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Choose Fact Families to Quiz on:")
                .foregroundColor(.black)
                .font(.custom(appFont, size: 20))
            HStack {
                FactFamilyButton(value: 0)
                FactFamilyButton(value: 1)
                FactFamilyButton(value: 2)
                FactFamilyButton(value: 3)
            }
            HStack {
                FactFamilyButton(value: 4)
                FactFamilyButton(value: 5)
                FactFamilyButton(value: 6)
                FactFamilyButton(value: 7)
            }
            HStack {
                FactFamilyButton(value: 8)
                FactFamilyButton(value: 9)
                FactFamilyButton(value: 10)
            }
        }.padding(.top, 16)
    }
}

struct NumberOfQuestionsSelector: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Choose the number of question in each quiz:")
                .foregroundColor(.black)
                .font(.custom(appFont, size: 20))
            Picker("", selection: $settings.numberOfQuestionInQuiz) {
                Text("10").tag(10)
                Text("20").tag(20)
                Text("30").tag(30)
            }.pickerStyle(SegmentedPickerStyle())
                .background(Color.yellow)
                .cornerRadius(8)
                .padding(.horizontal, 16)
        }.padding(.top, 16)
    }
}

struct FactFamilyButton: View {
    @EnvironmentObject var userSettings: UserSettings
    let value: Int
    
    private let width = (UIScreen.main.bounds.width / 4) - 16
    private let height = (UIScreen.main.bounds.height / 15)
    
    private var isValueIncluded: Bool {
        return userSettings.settings.factFamilies.contains(value)
    }
    
    private func addOrRemoveFromFactFamily() {
        if isValueIncluded {
            userSettings.settings.factFamilies.remove(value)
        } else {
            userSettings.settings.factFamilies.insert(value)
        }
    }
    
    var body: some View {
        Button(action: { self.addOrRemoveFromFactFamily() }) {
            Text("\(value)'s")
                .foregroundColor(.black)
                .font(.custom(appFont, size: 30))
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 2))
        .background(isValueIncluded ? Color.yellow : Color.gray)
    }
}

struct QuizSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        QuizSettingsView(onDismiss: {})
    }
}
