//
//  FavoriteMovies.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 08/09/2021.
//

import SwiftUI
import Kingfisher


struct FavoriteMovies: View {
    
    @State var bindingValues: BindingValues
    
    let gridLayout = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50))
    ]
    
    let thirdScreenWidth = UIScreen.main.bounds.width / 3
    let thirdScreenHeight = UIScreen.main.bounds.height / 3
    
    var body: some View {
        ScrollView {
            if bindingValues.favoriteMoviesCapacity == 0 {
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
                    ForEach(0..<bindingValues.favoriteMoviesCapacity, id: \.self) { index in
                        singleFavoriteMovieView(index: Int(index))
                    }
                })
            }
        }
    }
    
    func singleFavoriteMovieView(index: Int) -> some View {
        ZStack {
        Button(action: {
            bindingValues.movieTitle = bindingValues.favTitles[index]
            bindingValues.movieYear = bindingValues.favYears[index]
            bindingValues.movieOverview = bindingValues.favOverviews[index]
            bindingValues.movieImage = bindingValues.favPosters[index]
            bindingValues.isFullMovieView = true
        }, label: {
            ZStack {
                imageFunction(index: index)
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: thirdScreenWidth, height: 50, alignment: .center)
                            .foregroundColor(.blue)
                        VStack {
                            Text("\(bindingValues.favTitles[index])")
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
                    Button(action:{
                        bindingValues.movieTitle = bindingValues.favTitles[index]
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
                Spacer()
            }
        }
    }
    
    func imageFunction(index: Int) -> some View {  //Image from URL and not ontop of system image....  ###################################
        KFImage(URL(string: bindingValues.imagePath + bindingValues.favPosters[index]))
            .resizable()
            .scaledToFit()
    }
}

struct FacoriteMovies_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMovies(bindingValues: BindingValues())
    }
}
