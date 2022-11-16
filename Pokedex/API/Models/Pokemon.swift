//
//  Pokemon.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/16/22.
//

import Foundation

// MARK: Pokemon
struct Pokemon: Codable, Hashable {
    var id: String {
        get {
            return name
        }
    }
    var pokeID: String {
        get {
            return self.sprites.frontDefault.split(separator: "/").last?.split(separator: ".").first?.description ?? "0"
        }
    }
    let sprites: Sprites
    let types: [TypeElement]
    
    let name: String
    let stats: [Stat]
    
    // Equitable conformance
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.name == rhs.name
    }
    
    // MARK: Sprites
    struct Sprites: Codable, Hashable {
        static func == (lhs: Pokemon.Sprites, rhs: Pokemon.Sprites) -> Bool {
            lhs.id == rhs.id
        }
        
        var id: String {
            get {
                return frontDefault
            }
        }
        var frontDefaultURL: URL {
            if let url = URL(string: frontDefault) {
                return url
            }
            // Show the sprite for missingno if this specific URL didnt work
            return URL(string: "https://wiki.p-insurgence.com/images/0/09/722.png")!
            
        }
        let frontDefault: String
        let other: Other?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case other
            
        }
    }
    
    // MARK: - Other
    struct Other: Codable, Hashable {
        let officialArtwork: OfficialArtwork

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    // MARK: Sprites
    struct OfficialArtwork: Codable, Hashable {
        var id: String {
            get {
                return frontDefault
            }
        }
        var frontDefaultURL: URL {
            if let url = URL(string: frontDefault) {
                return url
            }
            // Show the sprite for missingno if this specific URL didnt work
            return URL(string: "https://wiki.p-insurgence.com/images/0/09/722.png")!
            
        }
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    // MARK: - Species
    struct Species: Codable, Hashable {
        var id: String {
            get {
                return name
            }
        }
        let name: String
        let url: String
    }
    
    // MARK: - Stat
    struct Stat: Codable, Hashable, Identifiable {
        var id: String {
            stat.name
        }
        
        let baseStat, effort: Int
        let stat: Species

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort, stat
        }
    }
    
    // MARK: - TypeElement
    struct TypeElement: Codable, Hashable, Identifiable {
        var id: String {
            get {
                return type.id
            }
        }
        let slot: Int
        let type: Species
    }
}
