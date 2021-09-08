//
//  MoviesPageLayout.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 08/09/2021.
//

import SwiftUI


struct MoviesPageLayout: View {
    
    @ObservedObject var bindingValues: BindingValues
    
    let thirdScreenWidth = UIScreen.main.bounds.width / 3
    let thirdScreenHeight = UIScreen.main.bounds.height / 3
    
    let gridLayout = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50))
    ]
    
    var body: some View {
        ScrollView {
            ScrollViewReader { value in
                LazyVGrid(columns: gridLayout, content: {
                    ForEach(0..<bindingValues.pageMoviesCapacity, id: \.self) { index in
                        singleMovieView(index: index)
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
                            Text("Load more...")
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
    
    func imageFunc(index: Int) -> some View {  //Image from URL and not ontop of system image....  ###################################
        Image(systemName: "person.fill")
            .data(url: URL(string: bindingValues.imagePath + bindingValues.allPosters[index])!)
            .resizable()
            .scaledToFit()
    }
    
    
    func titleAndYearFunc(index: Int) -> some View {
        HStack {
            Text("\(bindingValues.allTitles[index])") //title
                .font(.body)
                .scaledToFit()
            Text("- \(String(bindingValues.allYears[index].dropLast(6)))") //year
            
            Spacer()
        }
    }
}
