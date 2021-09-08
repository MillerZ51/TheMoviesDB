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
               // moviesOnTopOfMovies
                MoviesPageLayout(bindingValues: bindingValues)
            case 1:
                FavoriteMovies(bindingValues: bindingValues)
            default:
              //  moviesOnTopOfMovies
                MoviesPageLayout(bindingValues: bindingValues)
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

