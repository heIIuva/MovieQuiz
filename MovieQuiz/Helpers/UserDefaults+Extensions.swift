//
//  UserDefaults+Extensions.swift
//  MovieQuiz
//
//  Created by big stepper on 5/29/24.
//

import Foundation


extension UserDefaults {
    enum Keys: String, CaseIterable {
        case correct
        case bestGame
        case gamesCount
        case correctAnswers
        case total
        case date
        case totalAccuracy
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
