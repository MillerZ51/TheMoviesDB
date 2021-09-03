//
//  ContentView.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 23/08/2021.
//

import SwiftUI

extension Image {
    func data(url:URL) -> Self {

        if let data = try? Data(contentsOf: url) {

            return Image(uiImage: UIImage(data: data)!)
            .resizable()
        }
        return self
        .resizable()
    }
}

struct ContentView: View {
    
    @ObservedObject var bindingValues = BindingValues()
    @State var movie: Movie?

    let imagePath = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2"
    let tabsNames = ["Popular", "Favorite", "Now Playing"]
    let thirdScreenWidth = UIScreen.main.bounds.width / 3
    let thirdScreenHeight = UIScreen.main.bounds.height / 3
    let gridLayout = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50))
    ]
    let dataOfFavorite = UserDefaults.standard.data(forKey: "favorite")

    
    var body: some View {
        ZStack {
            tabViewApp
            
            if bindingValues.isFullMovieView == true {
                popoverMovie
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if dataOfFavorite != nil {
                bindingValues.get()
                bindingValues.copy()
            }
        }
    }
    
    var tabViewApp: some View {
        VStack {
            switch bindingValues.selectedTabIndex { //Page
            case 0:
                moviesOnTopOfMovies
            case 1:
                myFavoriteMovies
            default:
                moviesOnTopOfMovies
            }
            HStack { //Tab Buttons
                ForEach(0..<3) { num in
                    Button(action: {
                        bindingValues.selectedTabIndex = num
                        bindingValues.isFullMovieView = false
                        bindingValues.getData()
                        
                    }, label: {
                        Spacer()
                        if num == bindingValues.selectedTabIndex {
                            Text("\(tabsNames[num])")
                                .foregroundColor(.blue)
                        } else {
                            Text("\(tabsNames[num])")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    })
                }
                .multilineTextAlignment(.center)
                .id(UUID())
                .font(.title)
                .foregroundColor(.white)
                .padding(.vertical, 15)
            }
        }
    }
    
    var popoverMovie: some View {
        ZStack {
        HStack {
            Image(systemName: "person.fill")
                .data(url: URL(string: imagePath + (bindingValues.movieImage))!)
                .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.height / 3, alignment: .center)
                .border(Color.black)
                .padding(.trailing, 5)
                .scaledToFit()
            
            VStack {
                VStack {
                    HStack {
                        Text(bindingValues.movieTitle)
                            .bold()
                            .padding(.top, 15)
                            .padding(.trailing, 15)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                    HStack {
                        Text(bindingValues.movieYear)
                            .font(.caption)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .scaledToFill()
                        Spacer()
                    }
                }
                ScrollView {
                    Text(bindingValues.movieOverview)
                        .font(.caption)
                        .padding(.bottom, 15)
                        .multilineTextAlignment(.leading)
                    Text("\n\n")
                }
                Spacer()
            }
            Spacer()
        }
            HStack {
                Spacer()
                VStack {
                    Button(action:{
                        bindingValues.isFullMovieView = false
                    }, label:{
                        Text("X")
                            .foregroundColor(.black)
                            .font(.title)
                            .bold()
                    })
                    .padding(5)
                    
                    Spacer()
                    //FAVORITE
                    if bindingValues.titles.contains(bindingValues.movieTitle) {
                        
                        heartButtonFill
                    } else {
                        heartButtonUnfill
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 3, alignment: .center)
        .border(Color.black)
        .background(Color.blue)
        .scaledToFill()
    }
    
    var heartButtonUnfill: some View {
        Button(action:{  //SAVE MOVIE TO JSON FILE
            bindingValues.saveFavoriteData()
        }, label:{
            Image(systemName: "heart")
                .foregroundColor(.red)
                .font(.system(size: 30))
                .frame(width: 50, height: 50, alignment: .center)
                .background(Color.black)
                .cornerRadius(15.0)
        })
        .padding(5)
    }
    
    var heartButtonFill: some View {
        Button(action:{
            bindingValues.delete()
        }, label:{
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.system(size: 30))
                .frame(width: 50, height: 50, alignment: .center)
                .background(Color.black)
                .cornerRadius(15.0)
        })
        .padding(5)
    }
    
    var myFavoriteMovies: some View {
        ScrollView {
            if bindingValues.moviesCapacity == 0{
                VStack {
                    Spacer()
                    Text("No Favorite Movies")
                        .font(.title3)
                        .foregroundColor(.white)
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.black)
                        .cornerRadius(15.0)
                }
            } else {
                LazyVGrid(columns: gridLayout, content: {
                    ForEach(0..<bindingValues.moviesCapacity, id: \.self) { index in
                        singleFavoriteMovieView(index: Int(index))
                    }
                 //   .id(UUID())
                })
            }
        }
    }
    
    func singleFavoriteMovieView(index: Int) -> some View {
        ZStack {
        Button(action: {
            bindingValues.movieTitle = bindingValues.titles[index]
            bindingValues.movieYear = bindingValues.years[index]
            bindingValues.movieOverview = bindingValues.overviews[index]
            bindingValues.movieImage = bindingValues.posters[index]
            bindingValues.isFullMovieView = true
        }, label: {
            ZStack {
           //     Image(URL(string: imagePath + bindingValues.Posters[index]))
                Image(systemName: "person.fill")
                    .data(url: URL(string: imagePath + bindingValues.posters[index])!)
                    .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
                    .scaledToFit()
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: thirdScreenWidth, height: 50, alignment: .center)
                            .foregroundColor(.blue)
                        VStack {
                            Text("\(bindingValues.titles[index])")
                                .font(.body)
                                .bold()
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: thirdScreenWidth - 10, height: 50, alignment: .center)
                        }
                    }
                }
            }
            .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
            .scaledToFit()
        })
            VStack {
                HStack {
                    Spacer()
                    Button(action:{  //SAVE MOVIE TO JSON FILE
                        bindingValues.movieTitle = bindingValues.titles[index]
                        bindingValues.delete()
                    }, label:{
                        Image(systemName: "heart.fill") //fill if in JSON file
                            .foregroundColor(.red)
                            .font(.system(size: 30))
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(Color.black)
                            .cornerRadius(15.0)
                    })
                    .padding(5)
                }
                Spacer()
            }
        }
    }
    
    var moviesOnTopOfMovies: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, content: {
                ForEach(0..<bindingValues.allMoviesCapacity, id: \.self) { index in
                    singleMovieView(index: index)
                        .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
                }
                .id(UUID())
            })
        }
        .onAppear{
            bindingValues.getData()
        }
    }
    
    func singleMovieView(index: Int) -> some View {
        Button(action: {
            bindingValues.movieTitle = bindingValues.allTitles[index]
            bindingValues.movieYear = bindingValues.allYears[index]
            bindingValues.movieOverview = bindingValues.allOverviews[index]
            bindingValues.movieImage = bindingValues.allPosters[index]
            bindingValues.isFullMovieView = true
        }, label: {
            ZStack {
                imageFunc(index: index) //index
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: thirdScreenWidth, height: 50, alignment: .center)
                            .foregroundColor(.blue)
                        VStack {
                            Text("\(bindingValues.allTitles[index])") //title
                                .font(.body)
                                .bold()
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: thirdScreenWidth - 10, height: 50, alignment: .center)
                        }
                    }
                }
            }
            .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
            .scaledToFit()
        })
    }
    
    func imageFunc(index: Int) -> some View {
        Image(systemName: "person.fill")
            .data(url: URL(string: imagePath + bindingValues.allPosters[index])!)
            .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
            .scaledToFit()
    }
    
    func titleAndYearFunc(index: Int) -> some View {
        HStack {
            Text("\(bindingValues.allTitles[index])") //title
                .font(.body)
                .scaledToFit()
            Text("- \(String(bindingValues.allYears[index].dropLast(6)))") //year
            //.font(.footnote)
            
            Spacer()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

