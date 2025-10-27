//
//  EpisodesUseCase.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 27/10/25.
//

import Foundation

internal final class EpisodesUseCase: EpisodesUseCaseProtocol {
    
    private let episodesRepository: EpisodesRepositoryProtocol
    
    init(episodesRepository: EpisodesRepositoryProtocol = EpisodesRepository()) {
        self.episodesRepository = episodesRepository
    }
    
    func getEpisodes(from urls: [String]) async throws -> [EpisodeData] {
        
        let ids = urls.compactMap { URL(string: $0)?.lastPathComponent }.joined(separator: ",")
        
        let response = try await episodesRepository.getEpisodes(from: ids)
        
        guard let episodesArray = response as [EpisodeData]?, !episodesArray.isEmpty else {
            throw GenericError(codigo: "", error: "No se encontraron episodios para este personaje")
        }
        
        return episodesArray
    }
}
