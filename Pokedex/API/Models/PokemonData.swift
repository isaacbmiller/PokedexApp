//
//  PokemonData.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/16/22.
//

import Foundation

// MARK: PokemonData
protocol PokemonData: Identifiable {
    var id: Int { get }
    var pokemon: Pokemon? { get }
    var name: String { get }
}
