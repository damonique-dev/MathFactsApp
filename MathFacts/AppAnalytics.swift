//
//  Analytics.swift
//  MathFacts
//
//  Created by Damonique Blake on 11/24/19.
//  Copyright © 2019 Damonique Blake. All rights reserved.
//

import Firebase
import Foundation

struct AppAnalytics {
    static func logQuizCompetionEvent(quiz: Quiz, factFamily: Set<Int>) {
        Analytics.logEvent("quiz_completed", parameters: [
            "quiz_operation" : quiz.operation.toString(),
            "number_of_questions" : quiz.questions.count,
        ])
    }
}
