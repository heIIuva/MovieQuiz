//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by big stepper on 5/18/24.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func failedToLoadData(with error: Error)
}
