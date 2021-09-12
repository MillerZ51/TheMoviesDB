//
//  BindingValues.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 31/08/2021.
//

import Foundation

class BindingValues: ObservableObject {
    
    let apiKey = "?api_key=2c46288716a18fb7aadcc2a801f3fc6b"
    let popMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=2c46288716a18fb7aadcc2a801f3fc6b"
    let newMoviesURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=2c46288716a18fb7aadcc2a801f3fc6b"
    let page = "&page=" //Number
    @Published var pageNumber = 1
    
    @Published var selectedTabIndex = 0
    
    @Published var isFullMovieView: Bool = false
    
    let imagePath = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2"
    
    //popover view
    @Published var movieTitle = "Title"
    @Published var movieYear = "Year"
    @Published var movieOverview = "Overview"
    @Published var movieImage = "ImageURL"
    
    @Published var popularMovies: [Movie] = []
    
    @Published var favorite: [Movie] = [] {didSet {save(); copy()}}
    
    @Published var favoriteMoviesCapacity = 0
    @Published var pageMoviesCapacity = 0
    @Published var dateValue: Double = 0.0
    
    //Popular and Now Playing Movies
    @Published var allTitles = [String](repeating: "Title", count: 20) {
        didSet { pageMoviesCapacity = allTitles.capacity }}
    @Published var allOverviews: [String] = []
    @Published var allYears: [String] = []
    @Published var allPosters: [String] = []
    
    //Favorite Movies
    @Published var favTitles = [String](repeating: "Title", count: 20) {
         didSet { favoriteMoviesCapacity = favTitles.capacity }}
    @Published var favOverviews: [String] = []
    @Published var favYears: [String] = []
    @Published var favPosters: [String] = []
    
    
    func loadFromUserDefaults() {
        guard
            let data = UserDefaults.standard.data(forKey: "popular"),
            let savedMovies = try? JSONDecoder().decode([Movie].self, from: data)
        else { return }
        
        self.popularMovies = savedMovies
    }
    
    func delete() {     //Favorites
        let index = self.favTitles.firstIndex(of: self.movieTitle)
        self.favorite.remove(at: index ?? 0)
    }
    
    func save() {     //Favorites
        if let encoded = try? JSONEncoder().encode(favorite) {
            UserDefaults.standard.set(encoded, forKey: "favorite")
        }
    }
    
    func saveFavoriteData() {     //Favorites
        self.favorite.append(Movie(title: movieTitle, year: movieYear, posterImage: movieImage, overview: movieOverview))
        self.save()
    }
    
    func get() {
        guard
            let data = UserDefaults.standard.data(forKey: "favorite"),     //Favorites
            let savedMovies = try? JSONDecoder().decode([Movie].self, from: data)
        else { return }
        
        self.favorite = savedMovies
    }
    
    func copy() {
        self.favTitles = favorite.map({return $0.title})
        self.favOverviews = favorite.map({return $0.overview})
        self.favYears = favorite.map({return $0.year})
        self.favPosters = favorite.map({return $0.posterImage})
        self.favoriteMoviesCapacity = self.favTitles.capacity
    }
    
    func getData() {  //get Data from JSON
        var usedURL: String = ""
        if selectedTabIndex == 0 { //index of page
            usedURL = popMoviesURL + page + String(pageNumber)
        } else if selectedTabIndex == 1 {
            usedURL = newMoviesURL
        } else {
            usedURL = newMoviesURL + page + String(pageNumber)
        }
        
        URLSession.shared.dataTask(with: URL(string: usedURL)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var result: MoviesData?
            do {
                result = try JSONDecoder().decode(MoviesData.self, from: data)
                
            } catch {
                print("failed to convert: \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
        
            DispatchQueue.main.async {
                self.allTitles = json.movies.map({return $0.title})
                self.allOverviews = json.movies.map({return $0.overview})
                self.allYears = json.movies.map({return $0.year})
                self.allPosters = json.movies.map({return $0.posterImage})
            }
        })
        .resume()
    }
}
