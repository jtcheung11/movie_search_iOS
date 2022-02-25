//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Jonmichael Cheung on 2/24/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

//MARK: - Outlets
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    
//MARK: - Properties
    var movie: Movie? {
        didSet {
            updateView()
        }
    }
//MARK: - Helper Methods
    func updateView() {
        guard let movie = movie else { return }
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = String(movie.vote_average)
        movieDescriptionLabel.text = movie.overview
        
        MovieController.fetchMoviePosterFor(movie: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self.moviePosterImageView?.image = poster
                case .failure(let error):
                    self.moviePosterImageView?.image = UIImage(systemName: "photo.on.rectangle")
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
}//End of class
