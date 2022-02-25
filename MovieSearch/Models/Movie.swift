//
//  Movie.swift
//  MovieSearch
//
//  Created by Jonmichael Cheung on 2/24/22.
//

import Foundation


struct TopLevelObject: Decodable {
    let results: [Movie]
}
//Kept running into "Movie not conforming to Decodable
struct Movie: Decodable {
    let title: String
    let vote_average: Double
    let overview: String
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case vote_average = "vote_average"
        case overview = "overview"
        case poster = "poster_path"
    }
}
