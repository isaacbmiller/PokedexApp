//
//  ContentView.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/14/22.
//
// UI inspired by https://dribbble.com/shots/6540871-Pokedex-App/attachments/6540871-Pokedex-App?mode=media

import SwiftUI

struct ContentView: View {
    @ObservedObject var pokeAPI: PokeAPI
    @State var selectedPokemon: Pokemon? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                InfiniteGrid(data: $pokeAPI.PokemonLinks, isLoading: $pokeAPI.isLoading, loadMore: pokeAPI.loadMore, content: {data in
                    // Create a link to each pokemons page on load
                    NavigationLink(destination: IndividualPokemonView(pokemon: data.pokemon!), tag: data.pokemon!, selection: $selectedPokemon) {
                        PokemonCell(pokemonData: data)
                            .onTapGesture {
                                selectedPokemon = data.pokemon!
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 2)
                    }
                    
                    
                })
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Pokedex")
        }
        
    }
}

struct PokemonCell: View {
    var pokemonData: any PokemonData
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(pokemonData.pokemon!.name.capitalized)
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .padding(.bottom, 3)
                    ForEach(pokemonData.pokemon!.types) { pokemonType in
                        TypePill(pokemonType: pokemonType)
                    }
                    Spacer()
                }
                Spacer()
                
                CacheAsyncImage(url: pokemonData.pokemon!.sprites.other!.officialArtwork.frontDefaultURL) { phase in
                    phase.image?
                        .resizable()
                        .frame(height: 75)
                        .aspectRatio(contentMode: .fit)
                        
                }
                
            }
            .padding(.all)
            
            Image("PokeballClear")
                .opacity(0.4)
                .zIndex(-1)
                .padding(.bottom, 5)
                .padding(.trailing, 5)
            
        }
        
        .frame(height: 125)
        .background(Color(uiColor: pokemonData.pokemon!.typeColor))
        .cornerRadius(10)
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .shadow(radius: 10)
            
    }
    
    struct TypePill: View {
        var pokemonType: Pokemon.TypeElement
        var body: some View {
            ZStack(alignment: .center) {
                Text(pokemonType.type.name.capitalized)
                    .foregroundColor(.white)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background {
                        Color.white
                            .foregroundColor(.white)
                            .opacity(0.4)
                            .cornerRadius(20)
                    }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(pokeAPI: PokeAPI())
    }
}

struct InfiniteGrid<Data, Content>: View
where Data : RandomAccessCollection, Data.Element : Hashable, Data.Element : PokemonData, Content : View  {
  @Binding var data: Data // 1
  @Binding var isLoading: Bool // 2
  let loadMore: () async throws -> () // 3
  let content: (Data.Element) -> Content // 4

  init(data: Binding<Data>,
       isLoading: Binding<Bool>,
       loadMore: @escaping () async throws -> (),
       @ViewBuilder content: @escaping (Data.Element) -> Content) { // 5
    _data = data
    _isLoading = isLoading
    self.loadMore = loadMore
    self.content = content
  }

  var body: some View {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))]) {
          ForEach(data, id: \.self) { item in
            content(item)
              .task {
                  if item == data.last { // 6
                      try? await loadMore()
                  }
                  
              }
          }
          if isLoading { // 7
            ProgressView()
              .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
          }
   }.task {
       try? await loadMore()
   } // 8
  }
}
