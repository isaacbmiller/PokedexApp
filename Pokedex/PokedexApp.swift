//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/14/22.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(pokeAPI: PokeAPI())
        }
    }
}
