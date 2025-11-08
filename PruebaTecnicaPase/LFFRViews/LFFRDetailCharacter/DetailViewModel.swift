//
//  DetailViewModel.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 26/10/25.
//

import Foundation

final class DetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isFavorite: Bool = false
    @Published var watchedEpisodes: [Int] = []
    @Published var episodesArray: [EpisodeData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    // MARK: - Dependencies
    private let episodesUseCase: EpisodesUseCaseProtocol
    
    // MARK: - Initializer
    init(episodesUseCase: EpisodesUseCaseProtocol = EpisodesUseCase()) {
        self.episodesUseCase = episodesUseCase
    }
    
    func toggleEpisodes(for episode: EpisodeData) {
        guard let episodeid = episode.id else { return }
        
        do {
            if watchedEpisodes.contains(episodeid) {
                try CoreDataManager.shared.delete(EpisodeData.self, id: "\(episodeid)")
                print("Episodio \(episodeid) marcado como NO visto")
            } else {
                CoreDataManager.shared.save(episode)
                print("Episodio \(episodeid) marcado como visto")
            }
        } catch {
            errorMessage = "No se pudo eliminar el episodio \(episodeid): \(error.localizedDescription)"
            showErrorAlert = true
            print(" Error al eliminar el episodio: \(error)")
        }
        
        fetchEpisodesWatched()
    }
    
    func isEpisodeWatched(_ episodeid: Int) -> Bool {
        return watchedEpisodes.contains(episodeid)
    }
    
    func fetchEpisodesWatched() {
        let savedEpisodes: [EpisodeData] = CoreDataManager.shared.fetchAll(EpisodeData.self)
        watchedEpisodes = savedEpisodes.compactMap { $0.id }
        print("Episodios vistos cargados: \(watchedEpisodes.count)")
    }
    
    
    // MARK: - Agregar o quitar favorito
    func toggleFavorite(for character: CharacterData) {
        guard let id = character.id else { return }
        
        do {
            if isFavorite {
                try CoreDataManager.shared.delete(CharacterData.self, id: "\(id)")
                print("Eliminado de favoritos: \(id)")
            } else {
                CoreDataManager.shared.save(character)
                print("Agregado a favoritos: \(id)")
            }
            
            isFavorite.toggle()
            
        } catch {
            self.errorMessage = "No se pudo borrar el favorito \(id): \(error.localizedDescription)"
            self.showErrorAlert = true
            print(" Error al eliminar de favoritos: \(error)")
        }
    }
    
    
    // MARK: - Verificar si ya es favorito
    func fetchFavorites(for id: Int) {
        let savedCharacters: [CharacterData] = CoreDataManager.shared.fetchAll(CharacterData.self)
        isFavorite = savedCharacters.contains { $0.id == id }
    }
    
    // MARK: - Obtener episodios del personaje
    func fetchEpisodes(for character: CharacterData) {
        
        guard let episodeUrls = character.episode, !episodeUrls.isEmpty else {
            episodesArray = []
            return
        }
        
        isLoading = true
        showErrorAlert = false
        errorMessage = ""
        
        Task { @MainActor in
            do {
                let response = try await episodesUseCase.getEpisodes(from: episodeUrls)
                setupResponse(response)
                
            } catch let error as GenericError {
                print("Código: \(error.codigo ?? ""), Mensaje: \(error.error ?? "")")
                episodesArray.removeAll()
                self.errorMessage = "Código: \(error.codigo ?? ""), Mensaje: \(error.error ?? "")"
                self.showErrorAlert = true
                
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Private Methods
    private func setupResponse(_ response: [EpisodeData]) {
        episodesArray = response
        
    }
}
