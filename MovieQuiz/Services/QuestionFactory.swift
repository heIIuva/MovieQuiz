//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by big stepper on 5/17/24.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    private let moviesLoader: MoviesLoading
    
    private let ratingList: [String] = ["больше", "меньше"]
    
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.failedToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                self.delegate?.failedToLoadData(with: error)
                print("Failed to load image")
            }
            
            let rating = Double(movie.rating) ?? 0
            
            let difference: String = ratingList.randomElement() ?? ""
            let differenceValue: Int = Int.random(in: 3...8)
            
            let text = "Рейтинг этого фильма \(difference) чем \(differenceValue)?"
            var correctAnswer: Bool
            if difference == ratingList[0] {
                correctAnswer = rating > Double(differenceValue)
            } else {
                correctAnswer = rating < Double(differenceValue)

            }
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
 }




// MARK: - Mock
/*
 private let questions: [QuizQuestion] = [
         QuizQuestion(
             image: "The Godfather",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
         QuizQuestion(
             image: "The Dark Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
         QuizQuestion(
             image: "Kill Bill",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
         QuizQuestion(
             image: "The Avengers",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
         QuizQuestion(
             image: "Deadpool",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
         QuizQuestion(
             image: "The Green Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
         QuizQuestion(
             image: "Old",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
         QuizQuestion(
             image: "The Ice Age Adventures of Buck Wild",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
         QuizQuestion(
             image: "Tesla",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
         QuizQuestion(
             image: "Vivarium",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false)
 ]
 */
