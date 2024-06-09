//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by big stepper on 5/19/24.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}
