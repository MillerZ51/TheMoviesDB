//
//  CellcomMovieDBApp.swift
//  CellcomMovieDB
//
//  Created by Omer Miller on 23/08/2021.
//

import SwiftUI

@main
struct CellcomMovieDBApp: App {
    
    @StateObject var bindingValues = BindingValues()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bindingValues)
        }
    }
}
