//
//  UserSettings.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/24/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var factFamilies: Set = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    func resetFactFamilies() {
        factFamilies = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    }
}
