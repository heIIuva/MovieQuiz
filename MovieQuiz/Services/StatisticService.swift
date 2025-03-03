//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by big stepper on 5/27/24.
//

import UIKit


final class StatisticService: StatisticServiceProtocol {
    
    weak var delegate: UIViewController?
    
    private let storage: UserDefaults = .standard
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case correctAnswers
        case total
        case date
        case totalAccuracy
    }
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            GameResult(correct: storage.integer(forKey: Keys.correct.rawValue),
                       total: storage.integer(forKey: Keys.total.rawValue),
                       date: storage.object(forKey: Keys.date.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            storage.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }

    
    func store(correct: Int, total: Int, date: Date) {
        
        let bestGameAttempt = GameResult(correct: correct, total: total, date: date)
        
        if bestGameAttempt.isBetterThan(attempt: self.bestGame) {
            self.bestGame = bestGameAttempt
        }
        
        gamesCount += 1
        
        correctAnswers += correct
        
        if gamesCount != 0 {
            totalAccuracy = Double(correctAnswers) / (Double(gamesCount) * 10) * 100
        }
    }
    
}
