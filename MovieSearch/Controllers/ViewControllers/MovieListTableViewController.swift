//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by Jonmichael Cheung on 2/24/22.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    var movies: [Movie] = []
    
    //MARK: - Lifecycles Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
} //End of class

extension MovieListTableViewController: UISearchBarDelegate {
    //returned URL when searching Shrek: https://api.themoviedb.org/3/search/movie?api_key=ef402a745e402065e60c09afd93c00e3&query=Shrek returns correct data?
    func searchBarSearchButtonClicked(_ searchMovieDB: UISearchBar) {
        guard let searchTerm = searchBar.text,
              !searchTerm.isEmpty else { return }
        MovieController.fetchMovie(search: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}
