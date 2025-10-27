//
//  EpisodesRepository.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 27/10/25.
//

import Foundation

protocol EpisodesRepositoryProtocol {
    
    func getEpisodes(from ids: String) async throws -> [EpisodeData]

}
