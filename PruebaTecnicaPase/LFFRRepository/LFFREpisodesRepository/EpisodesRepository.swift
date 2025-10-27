//
//  EpisodesRepository.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 27/10/25.
//

import Foundation

internal final class EpisodesRepository: EpisodesRepositoryProtocol {
    
    func getEpisodes(from ids: String) async throws -> [EpisodeData] {
        
        let baseUrl = "https://rickandmortyapi.com/api/episode/\(ids)"
        
        do {
            return try await ApiManager.shared.request(
                baseUrl: baseUrl,
                method: .get,
                responseType: [EpisodeData].self
            )
        } catch {
            let single = try await ApiManager.shared.request(
                baseUrl: baseUrl,
                method: .get,
                responseType: EpisodeData.self
            )
            return [single]
        }
    }
}
