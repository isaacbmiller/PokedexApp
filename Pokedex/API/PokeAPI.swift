//
//  Pokemon.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/14/22.
//

import Foundation

struct ListResponse: Codable {
    let results: [PokemonLink]
}
protocol PokemonData: Identifiable {
    var id: Int { get }
    var pokemon: Pokemon? { get }
    var name: String { get }
}

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


struct Pokemon: Codable, Hashable {
    var id: String {
        get {
            return name
        }
    }
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.name == rhs.name
    }
    
    let sprites: Sprites
    let types: [TypeElement]
    
    let name: String
    let stats: [Stat]
    
    struct Sprites: Codable, Hashable {
        var id: String {
            get {
                return frontDefault
            }
        }
        var frontDefaultURL: URL {
            if let url = URL(string: frontDefault) {
                return url
            }
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
    struct Stat: Codable, Hashable {
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

struct PokedexError: Error {
    let message: String
}



class PokeAPI : ObservableObject{
    @Published var PokemonLinks = [PokemonLink]()
    @Published var isLoading = false
    var offset = 0
    var limit = 20
    
    private func loadPokemonLinks(offset: Int, limit: Int) async throws -> [PokemonLink] {
        if (offset < 0 || limit < 0) {
            throw PokedexError(message: "Offset or Limit out of range for pokedex list URL")
        }
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            throw PokedexError(message: "Invalid pokedex list URL")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ListResponse.self, from: data).results
        
    }
    
    private func loadSinglePokemon(pokemonLink: PokemonLink) async throws -> PokemonLink {
        if let url = pokemonLink.url {
            let (data, _) = try await URLSession.shared.data(from: url)
            //            print("data: \(String(data: data, encoding: .utf8)!)")
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                var newLink = pokemonLink
                guard let spriteURL = URL(string: pokemon.sprites.frontDefault) else {
                    print(":(")
                    throw PokedexError(message: "Invalid single pokemon image URL")
                }
                newLink.pokemon = pokemon
                return newLink
            } catch (let error) {
                print(error)
            }
            
        }
        return pokemonLink
    }
    
//    private func getImageData(pokemonLink: PokemonLink) async throws -> PokemonLink {
//        if let url = pokemonLink.spriteURL {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            var newLink = pokemonLink
//            newLink.spriteData = data
//            return newLink
//        }
//        return pokemonLink
//    }
    
    
    
    public func getFullPokemon(offset: Int, limit: Int) async throws -> [PokemonLink] {
        
        
        let individualLinks = try await loadPokemonLinks(offset: offset, limit: limit)
        print("individualLinks count: \(individualLinks.count)")
        
        let pokemonLinksWithImages = await withTaskGroup(of: PokemonLink?.self) { group in
            for individualLink in individualLinks {
                group.addTask {
                    return try? await self.loadSinglePokemon(pokemonLink: individualLink)
                }
            }
            return await group.reduce(into: [PokemonLink]()) { (result, pokemonLink) in
                if let pokemonLink = pokemonLink {
                    result.append(pokemonLink)
                } else {
                    print(pokemonLink)
                }
            }
        }
        print("pokemonLinksWithImages count: \(pokemonLinksWithImages.count)")
        return pokemonLinksWithImages
    }
    
    @MainActor
    public func loadMore() async throws {
        guard !isLoading else { return }
        DispatchQueue.main.async { [self] in
            isLoading = true
            offset += 20
        }
        let newPokemon: [PokemonLink] = (try? await getFullPokemon(offset: offset, limit: 20))?.sorted(by: { (pokemon1, pokemon2) in
            pokemon1.id < pokemon2.id
        }) ?? []
        self.PokemonLinks.append(contentsOf: newPokemon)
        DispatchQueue.main.async { [self] in
            isLoading = false
        }
        
        
    }
}
