//
//  GameResult.swift
//  MovieQuiz
//
//  Created by big stepper on 5/27/24.
//

import UIKit


struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(attempt: GameResult) -> Bool {
        correct >= attempt.correct
    }
}
