//
//  EpisodesUseCaseProtocol.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 27/10/25.
//

import Foundation

internal protocol EpisodesUseCaseProtocol {
    
    func getEpisodes(from urls: [String]) async throws -> [EpisodeData]
}
