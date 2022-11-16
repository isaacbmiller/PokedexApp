//
//  IndividualPokemonScreen.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/15/22.
//

import Foundation
import SwiftUI

// MARK: IndividualPokemonView
struct IndividualPokemonView: View {
    var pokemon: Pokemon
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: Back Button
            Button(action: {
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                    
                    
            })
            .padding(.leading, 25)
            .padding(.top, 20)
            // MARK: Main Body
            VStack(alignment: .center) {
                Spacer()
                // MARK: Title Section
                HStack() {
                    VStack(alignment: .leading, spacing: 10) {
                        // MARK: Name
                        Text(pokemon.name.capitalized)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        // MARK: Types
                        HStack {
                            ForEach(pokemon.types) { pokemonType in
                                PokemonCell.TypePill(pokemonType: pokemonType)
                            }
                            Spacer()
                        }
                    }.padding(.top, 50)
                    // MARK:  ID
                        Text(String(format: "#%03d", Int(pokemon.pokeID) ?? 0))
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top, 10)
                }.padding(.horizontal)
                    .padding(.bottom, 20)
                // MARK: Image
                CacheAsyncImage(url: pokemon.sprites.other!.officialArtwork.frontDefaultURL, scale: 1) { phase in
                    phase.image?
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fit)
                        
                        
                }
                // MARK: Base Stats
                VStack {
                    Spacer()
                    Text("Base Stats")
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.bottom, 20)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    ForEach(pokemon.stats) { stat in
                        StatView(stat: stat)
                            .padding(.bottom)
                    }
                    StatView(stat: getTotalStat(), total: 600)
                    Spacer()
                }.background(Color.white.cornerRadius(25))
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
                
            }.frame(maxWidth: .infinity)
        }.background(Color(uiColor: pokemon.typeColor))
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            
    }
    
    // MARK: Get Total Stats
    func getTotalStat() -> Pokemon.Stat {
        let total = pokemon.stats.reduce(0, {result, stat in
            result + stat.baseStat})
        return .init(baseStat: total, effort: 0, stat: .init(name: "Total", url: ""))
    }
    
    // MARK: StatView
    struct StatView: View {
        var stat: Pokemon.Stat
        var total: Double = 120
        
        var body: some View {
            HStack {
                Text(statName)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .frame(width: 100, alignment: .leading)
                    
                    
                Text(stat.baseStat.description)
                    .fontWeight(.bold)
                    .padding(.trailing, 10)
                Spacer()
                ProgressView(value: Double(stat.baseStat), total: Double(total))
                    .tint(stat.baseStat > Int(Double(0.5 * total)) ? .green : .red)
                
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity)
        }
        
        var statName: String {
            get {
                switch self.stat.stat.name {
                case "hp":
                    return "HP"
                case "attack":
                    return "Attack"
                case "defense":
                    return "Defense"
                case "special-attack":
                    return "Sp. Atk"
                case "special-defense":
                    return "Sp. Def"
                case "speed":
                    return "Speed"
                default:
                    return self.stat.stat.name
                }
            }
        }
        
    }
}

// MARK: Preview
struct IndividualPokemonView_Previews: PreviewProvider {
    let stats: [Pokemon.Stat] = []
    static let charmander: Pokemon = .init(sprites: .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png", other: .init(officialArtwork: .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png"))), types: [.init(slot: 1, type: .init(name: "fire", url: "https://pokeapi.co/api/v2/type/3/"))], name: "charmander", stats: [
        .init(baseStat: 45, effort: 0, stat: .init(name: "hp", url: "")),
        .init(baseStat: 49, effort: 0, stat: .init(name: "attack", url: "")),
        .init(baseStat: 49, effort: 0, stat: .init(name: "defense", url: "")),
        .init(baseStat: 65, effort: 0, stat: .init(name: "special-attack", url: "")),
        .init(baseStat: 65, effort: 0, stat: .init(name: "special-defense", url: "")),
        .init(baseStat: 45, effort: 0, stat: .init(name: "speed", url: "")),
    ])
    static let venosaur: Pokemon = .init(sprites: .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png", other: .init(officialArtwork: .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png"))), types: [.init(slot: 1, type: .init(name: "grass", url: "https://pokeapi.co/api/v2/type/3/"))], name: "Venosaur", stats: [
        .init(baseStat: 45, effort: 0, stat: .init(name: "hp", url: "")),
        .init(baseStat: 49, effort: 0, stat: .init(name: "attack", url: "")),
        .init(baseStat: 49, effort: 0, stat: .init(name: "defense", url: "")),
        .init(baseStat: 65, effort: 0, stat: .init(name: "special-attack", url: "")),
        .init(baseStat: 65, effort: 0, stat: .init(name: "special-defense", url: "")),
        .init(baseStat: 45, effort: 0, stat: .init(name: "speed", url: "")),
    ])
    
//    .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png", officialArtwork: .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png"))
    static var previews: some View {
        Group {
            IndividualPokemonView(pokemon: charmander)
                .previewLayout(PreviewLayout.sizeThatFits)
            IndividualPokemonView(pokemon: venosaur)
                .previewLayout(PreviewLayout.sizeThatFits)
        }
    }
}
