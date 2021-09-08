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
                PopMovieWindow(bindingValues: self.bindingValues)
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
                FavoriteMovies(bindingValues: bindingValues)
            default:
                moviesOnTopOfMovies
            }
            HStack { //Tab Buttons
                ForEach(0..<3) { num in
                    Button(action: {
                        bindingValues.selectedTabIndex = num
                        bindingValues.isFullMovieView = false
                        bindingValues.pageNumber = 1
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
   
    var moviesOnTopOfMovies: some View {
        ScrollView {
            ScrollViewReader { value in
                LazyVGrid(columns: gridLayout, content: {
                    ForEach(0..<bindingValues.allMoviesCapacity, id: \.self) { index in
                        singleMovieView(index: index)
                            .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
                            .id(index)
                    }

                    //Next Page
                    Button (action: {
                        bindingValues.pageNumber = bindingValues.pageNumber + 1
                        bindingValues.getData()
                        bindingValues.isFullMovieView = false
                        
                        value.scrollTo(1, anchor: .top)
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
                                .foregroundColor(.blue)
                            Text("Load more..")
                                .font(.body)
                                .bold()
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    })
                    .frame(width: thirdScreenWidth, height: thirdScreenHeight, alignment: .center)
                    .scaledToFit()
                })
            }
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
            .data(url: URL(string: bindingValues.imagePath + bindingValues.allPosters[index])!)
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

