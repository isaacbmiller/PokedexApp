//
//  Pokemon.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/14/22.
//

import Foundation

// MARK: PokeAPI
class PokeAPI : ObservableObject{
    @Published var PokemonLinks = [PokemonLink]()
    @Published var isLoading = false
    var offset = 0
    var limit = 20
    
    // MARK: getFullPokemon
    public func getFullPokemon(offset: Int, limit: Int) async throws -> [PokemonLink] {
        
        // Get the list of individual pokemon links
        let individualLinks = try await loadPokemonLinks(offset: offset, limit: limit)
        
        // Get the individual data for each pokemon and add it to the pokemon link
        // Creates a task group and does all loading in parallel
        let pokemonLinksWithPokemon = await withTaskGroup(of: PokemonLink?.self) { group in
            for individualLink in individualLinks {
                group.addTask {
                    return try? await self.loadSinglePokemon(pokemonLink: individualLink)
                }
            }
            return await group.reduce(into: [PokemonLink]()) { (result, pokemonLink) in
                if let pokemonLink = pokemonLink {
                    result.append(pokemonLink)
                }
            }
        }
        return pokemonLinksWithPokemon
    }
    
    // MARK: loadMore
    // This is called by the view when the last data member is shown
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
    
    // MARK: loadPokemonLinks
    // Gets the list of poekmon and their individual links for the given offset and limit
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
    
    // MARK: loadSinglePokemon
    // Gets the data for a single pokemon and returns is as a copy of the new pokemon link with the pokemon added
    private func loadSinglePokemon(pokemonLink: PokemonLink) async throws -> PokemonLink {
        if let url = pokemonLink.url {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                var newLink = pokemonLink
                newLink.pokemon = pokemon
                return newLink
            } catch (let error) {
                print(error)
            }
            
        }
        return pokemonLink
    }
    
    
}
