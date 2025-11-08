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
                
                if let imageUrl = navigationManager.selectedCharacter?.image, !imageUrl.isEmpty {
                    AsyncImageView(url: imageUrl)
                        .frame(height: 280)
                        .cornerRadius(15)
                        .clipped()
                }
                
                Text(navigationManager.selectedCharacter?.name ?? "Desconocido")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 5) {
                    HStack {
                        Text(navigationManager.selectedCharacter?.gender ?? "")
                        Text(navigationManager.selectedCharacter?.species ?? "")
                    }
                    
                    Text(navigationManager.selectedCharacter?.status ?? "")
                        .foregroundColor(
                            navigationManager.selectedCharacter?.status?.lowercased() == "alive" ? .green : .red
                        )
                    
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
                                Text(episode.name ?? "")
                                    .font(.subheadline)
                                Text(episode.episode ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.toggleEpisodes(for: episode)
                            } label: {
                                Image(systemName: viewModel.isEpisodeWatched(episode.id ?? 0) ? "eye.fill": "eye")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ButtonGeneric(
                    label: "Ver en mapa",
                    icon: "map.fill",
                    isSelected: false
                ) {
                    navigationManager.navigate(to: .MapsView)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            if let character = navigationManager.selectedCharacter,
               let id = character.id{
                viewModel.fetchEpisodes(for: character)
                viewModel.fetchFavorites(for: id)
                viewModel.fetchEpisodesWatched()
            }
        }
        
        .alert(isPresented: $viewModel.showErrorAlert){
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("Aceptar"))
                
            )
        }
    }
}
