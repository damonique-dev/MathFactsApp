//
//  UserSettings.swift
//  MathFacts
//
//  Created by Damonique Blake on 10/24/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import Foundation

fileprivate var savePath: URL!
fileprivate let encoder = JSONEncoder()
fileprivate let decoder = JSONDecoder()

class UserSettings: ObservableObject {
    @Published var settings: Settings
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            savePath = documentDirectory.appendingPathComponent("userData")
        } catch let error {
            fatalError("Couldn't create save state data with error: \(error)")
        }
        
        if let data = try? Data(contentsOf: savePath),
            let savedSettings = try? decoder.decode(Settings.self, from: data) {
            self.settings = savedSettings
        } else {
            self.settings = Settings()
        }
    }
    
    func resetFactFamilies() {
        settings.factFamilies = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    }
    
    func archiveSettings() {
        guard let data = try? encoder.encode(userSettings.settings) else {
            return
        }
        try? data.write(to: savePath)
    }
}

struct Settings: Codable {
    var factFamilies: Set = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
}
