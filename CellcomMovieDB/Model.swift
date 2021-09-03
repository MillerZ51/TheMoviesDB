//
//  Model.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 23/08/2021.
//

import Foundation

struct MoviesData: Codable {
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Codable, Identifiable {
    
    let id: String = UUID().uuidString
    var title: String
    var year: String
    var posterImage: String
    var overview: String
    
    private enum CodingKeys: String, CodingKey {
        case title, overview
        case year = "release_date"
        case posterImage = "poster_path"
    }
}
