//
//  FavoriteMovies.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 08/09/2021.
//

import SwiftUI


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
                    .data(url: URL(string: bindingValues.imagePath + bindingValues.posters[index])!)
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
}
/*
struct FacoriteMovies_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMovies()
    }
}
*/
