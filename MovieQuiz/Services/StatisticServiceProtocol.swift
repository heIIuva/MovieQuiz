//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by big stepper on 5/27/24.
//

import UIKit


protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct: Int, total: Int, date: Date)
}
