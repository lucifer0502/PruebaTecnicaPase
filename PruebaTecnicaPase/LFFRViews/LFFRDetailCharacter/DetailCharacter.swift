//
//  DetailGeneric.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//
import SwiftUI

struct DetailCharacter: View {
    
    @EnvironmentObject var navigationManager: NavigationManger
    @StateObject var viewModel = DetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                
                if let character = navigationManager.selectedCharacter,
                   let imageUrl = character.image, !imageUrl.isEmpty {
                    AsyncImageView(url: imageUrl)
                        .frame(height: 280)
                        .cornerRadius(15)
                        .clipped()
                }
                
                Text(navigationManager.selectedCharacter?.name ?? "")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 5) {
                    HStack {
                        Text(navigationManager.selectedCharacter?.gender ?? "")
                        Text(navigationManager.selectedCharacter?.species ?? "")
                    }
                    
                    Text(navigationManager.selectedCharacter?.status  ?? "")
                        .foregroundColor(navigationManager.selectedCharacter?.status?.lowercased()  == "alive" ? .green : .red)
                    
                    Text(navigationManager.selectedCharacter?.location?.name ?? "")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                
                ButtonGeneric(
                    label: "Favorito",
                    icon: viewModel.isFavorite ? "heart.fill" : "heart",
                    isSelected: viewModel.isFavorite
                ) {
                    if let character = navigationManager.selectedCharacter {
                        viewModel.toggleFavorite(for: character)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Episodios")
                        .font(.headline)
                    
                    ForEach(viewModel.episodesArray) { episode in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(episode.name ?? "Desconocido")
                                    .font(.subheadline)
                                Text(episode.episode ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    navigationManager.navigate(to: .MapsView)
                }) {
                    Text("Ver en mapa")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(20)
                }
                
                Spacer()
            }
            .padding()
        }
        
        .onAppear {
            if let character = navigationManager.selectedCharacter,
               let id = character.id {
                viewModel.fetchEpisodes(for: character)
                viewModel.fetchFavorites(for: id)
                
            }
        }
    }
}
