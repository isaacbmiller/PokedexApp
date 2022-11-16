//
//  PokemonList.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/16/22.
//

import Foundation

// MARK: ListResponse
struct ListResponse: Codable {
    let results: [PokemonLink]
}

// MARK: Link
struct PokemonLink: Codable, Identifiable, PokemonData, Hashable {
    var spriteURL: URL?
    
    var id: Int {
        get {
            return Int(url!.absoluteString.split(separator: "/").last!.description) ?? -1
        }
    }
    var name: String
    var url: URL?
    var pokemon: Pokemon?
}
