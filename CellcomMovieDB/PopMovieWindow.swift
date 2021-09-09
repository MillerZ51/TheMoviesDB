//
//  PopMovieWindow.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 08/09/2021.
//

import SwiftUI

struct PopMovieWindow: View {
    
    @ObservedObject var bindingValues: BindingValues
    
    
    var body: some View {
        ZStack {
        HStack {
            Image(systemName: "person.fill")
                .data(url: URL(string: bindingValues.imagePath + (bindingValues.movieImage))!)
                .resizable()
                .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.height / 3, alignment: .center)
                .border(Color.black)
                .scaledToFit()
                .padding(.trailing, 5)
            
            movieDetail
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
    }
    
    var movieDetail: some View {
        VStack {
            VStack {
                Text(bindingValues.movieTitle)
                    .bold()
                    .padding(.top, 15)
                    .padding(.trailing, 15)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.5)
                    
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
}
