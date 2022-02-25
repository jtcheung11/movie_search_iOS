//
//  MovieController.swift
//  MovieSearch
//
//  Created by Jonmichael Cheung on 2/24/22.
//

import Foundation
import UIKit

class MovieController {
    
//API Key: ef402a745e402065e60c09afd93c00e3
//Base URL: https://api.themoviedb.org/3
//imageBase URL: https://image.tmdb.org/t/p/w500/(imageEndpoint)


    //MARK: - URL bits
    static let baseURL = URL(string: "https://api.themoviedb.org")
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    
    static let queryKey = "query"
    static let apiKeyKey = "api_key"
    static let apiKeyValue = "ef402a745e402065e60c09afd93c00e3"

    //https://image.tmdb.org/t/p/w500/(imageEndpoint)
    static let posterBaseURL = URL(string: "https://image.tmdb.org/t/p/w500/")

//https://api.themoviedb.org/3/search/movie?api_key=ef402a745e402065e60c09afd93c00e3&query=Shrek60c09afd93c00e3
    //MARK: - Movie Fetch
    static func fetchMovie(search: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let movieQuery = URLQueryItem(name: queryKey, value: search)
        components?.queryItems = [apiQuery, movieQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.thrownError(error))) }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Movie status code: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            do{
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let movieResults = topLevelObject.results
                var movieArr: [Movie] = []
                
                for movie in movieResults {
                    movieArr.append(movie)
                }
                return completion(.success(movieArr))
                
            }catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchMoviePosterFor(movie: Movie, completion: @escaping ( Result<UIImage, NetworkError>) -> Void) {
        guard let posterBaseURL = posterBaseURL else { return completion(.failure(.invalidURL)) }
        guard let posterPath = movie.poster else { return completion(.failure(.noData))}
        let posterURL = posterBaseURL.appendingPathComponent(posterPath)
        print(posterURL)
        
        URLSession.shared.dataTask(with: posterURL) { data, response, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Poster sttus code: \(response.statusCode)")
            }
        }
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(image))
        
        }.resume()
    }


} //End of class
