//
//  FavoriteView.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 26/10/25.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject var favoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if favoriteViewModel.favorites.isEmpty {
                    VStack(spacing: 20) {
                        Image("morty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                        
                        Text("No hay personajes favoritos")
                            .font(.headline)
                    }
                
                } else {
                    List {
                        ForEach(favoriteViewModel.favorites) { character in
                            HStack {
                                AsyncImage(url: URL(string: character.image ?? "")) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } placeholder: {
                                    LoadingView()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(character.name ?? "")
                                        .font(.headline)
                                    Text(character.species ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(character.status ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(character.status == "Alive" ? .green : .red)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let character = favoriteViewModel.favorites[index]
                                favoriteViewModel.deleteFavorite(character: character)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favoritos")
            .onAppear {
                favoriteViewModel.fetchFavorites()
            }
        }
    }
}
