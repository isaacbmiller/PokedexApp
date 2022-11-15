//
//  ContentView.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/14/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pokeAPI: PokeAPI
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Pokedex")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.horizontal)
            InfiniteGrid(data: $pokeAPI.PokemonLinks, isLoading: $pokeAPI.isLoading, loadMore: pokeAPI.loadMore, content: {data in
                NavigationLink(destination: ContentView(pokeAPI: pokeAPI)) {
                    PokemonCell(pokemonData: data)
                }
                
            })
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Pokedex")
        
    }
}

struct PokemonCell: View {
    var pokemonData: any PokemonData
    var color: UIColor {
        get {
            if let pokemon = pokemonData.pokemon {
                return TypeColors.getColor(type: pokemon.types[0].type.name)
            }
            return .gray
        }
    }
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
                    ForEach(pokemonData.pokemon!.types) { pokemonType in
                        TypePill(pokemonType: pokemonType)
                    }
                }
//                .shadow(radius: 10)
                Spacer()
                
                CacheAsyncImage(url: pokemonData.pokemon!.sprites.frontDefaultURL) { phase in
                    phase.image
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 50)
            }
            .padding(.horizontal)
            
            Image("PokeballClear")
                .opacity(0.7)
                .zIndex(-1)
                .padding(.bottom, 5)
                .padding(.trailing, 5)
            
        }
        
        
        .background(Color(uiColor: self.color))
        .cornerRadius(10)
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .shadow(radius: 10)
            
    }
    
    struct TypePill: View {
        var pokemonType: Pokemon.TypeElement
        var body: some View {
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.4)
                    .cornerRadius(20)
                    
                Text(pokemonType.type.name.capitalized)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: 75, maxHeight: 25)
                
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
