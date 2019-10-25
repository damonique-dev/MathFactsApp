//
//  BlurredBackground.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/24/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import SwiftUI

struct BlurredBackground: View {
    let image: UIImage

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height)
            Color(.white).opacity(0.5)
        }.edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
