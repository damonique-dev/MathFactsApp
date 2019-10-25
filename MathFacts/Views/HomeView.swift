//
//  HomeView.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/23/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                BlurredBackground(image: UIImage(named:"background")!)
                VStack(spacing: 16) {
                    Text("Math Facts")
                        .font(.custom(appFont, size: 50))
                        .padding(8)
                    FactOperationButton(text: "Addition (+)", operation: .add)
                    FactOperationButton(text: "Subtraction (-)", operation: .subtract)
                    FactOperationButton(text: "Multiplication (x)", operation: .multiply)
                    Group {
                        Text("Division (÷)")
                            .foregroundColor(.black)
                            .font(.custom(appFont, size: 30))
                        + Text("(coming soon)")
                            .foregroundColor(.black)
                            .font(.custom(appFont, size: 15))
                    }.frame(width: UIScreen.main.bounds.width - 36, height: 75)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    .background(Color(.white).opacity(0.5))
                    NavigationLink(destination: QuizSettingsView(onDismiss: {})) {
                        Text("Settings")
                            .foregroundColor(.black)
                            .font(.custom(appFont, size: 30))
                            .frame(width: UIScreen.main.bounds.width - 36, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                            .background(Color.white)
                    }.padding(.top, 16)
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

struct FactOperationButton: View {
    let text: String
    let operation: Operation
    var body: some View {
        NavigationLink(destination: QuizView(operation: operation).navigationBarTitle("", displayMode: .inline).navigationBarBackButtonHidden(true).navigationBarHidden(true)) {
            Text(text)
                .foregroundColor(.black)
                .font(.custom(appFont, size: 30))
                .frame(width: UIScreen.main.bounds.width - 36, height: 75)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                .background(Color.white)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
