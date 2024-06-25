//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by big stepper on 5/19/24.
//

import UIKit

final class AlertPresenter: UIAlertController, AlertPresenterProtocol {

    weak var delegate: UIViewController?
    
    
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        //alert.view.accessibilityIdentifier = "Game_result"
        //alert.view.accessibilityValue = "\(result.title)-\(result.message)"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: {
            let alertButton = action.value(forKey: "__representer")
            let view = alertButton as? UIView
            view?.accessibilityIdentifier = "Result"
        })
        
    }
    
}

