//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by big stepper on 25/06/2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func enableButtons()
    func disableButtons()
    
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
