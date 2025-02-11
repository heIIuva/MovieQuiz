//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by big stepper on 6/9/24.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let image: URL
    
    var resizedImageURL: URL {

        let urlString = image.absoluteString

        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return image
        }
        
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case image = "image"
    }
    
}

