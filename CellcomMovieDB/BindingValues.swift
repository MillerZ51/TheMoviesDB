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
    
    //popover view
    @Published var movieTitle = "Title"
    @Published var movieYear = "Year"
    @Published var movieOverview = "Overview"
    @Published var movieImage = "ImageURL"
    
    @Published var popularMovies: [Movie] = []
    
    @Published var favorite: [Movie] = [] {
        didSet {
            save()
            copy()
        }
    }
    
    @Published var moviesCapacity = 0
    @Published var allMoviesCapacity = 0
    @Published var dateValue: Double = 0.0
    
    @Published var allTitles: [String] = ["Title"] {
        didSet {
            allMoviesCapacity = allTitles.capacity
        }
    }
    @Published var allOverviews: [String] = []
    @Published var allYears: [String] = []
    @Published var allPosters: [String] = []
    
    @Published var titles = ["Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title"] {
          didSet {
              moviesCapacity = titles.capacity
          }
      }
    @Published var overviews = ["Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title"]
    @Published var years = ["Year      ", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title"]
    @Published var posters = ["Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title", "Title"]
    
    
    func loadFromUserDefaults() {
        guard
            let data = UserDefaults.standard.data(forKey: "popular"),
            let savedMovies = try? JSONDecoder().decode([Movie].self, from: data)
        else { return }
        
        self.popularMovies = savedMovies
    }
    
    //Favorites
    func delete() {
        let index = self.titles.firstIndex(of: self.movieTitle)
        self.favorite.remove(at: index ?? 0)
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(favorite) {
            UserDefaults.standard.set(encoded, forKey: "favorite")
        }
    }
    
    func get() {
        guard
            let data = UserDefaults.standard.data(forKey: "favorite"),
            let savedMovies = try? JSONDecoder().decode([Movie].self, from: data)
        else { return }
        
        self.favorite = savedMovies
    }
    
    func copy() {
        self.titles = favorite.map({return $0.title})
        self.overviews = favorite.map({return $0.overview})
        self.years = favorite.map({return $0.year})
        self.posters = favorite.map({return $0.posterImage})
        self.moviesCapacity = self.titles.capacity
    }
    
    
    
    
    
    func getData() {
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
            
            //have data
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
    
    func saveFavoriteData() {
        self.favorite.append(Movie(title: movieTitle, year: movieYear, posterImage: movieImage, overview: movieOverview))
        self.save()
    }
    
}
