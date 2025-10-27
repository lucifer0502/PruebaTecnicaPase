//
//  CharacterRepository1.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//


import Foundation

internal final class CharactersRepository: CharactersRepositoryProtocol {
    
    func getCharacters(page: Int, filter: CharacterFilter?) async throws -> CharacterModel {
        
        let baseUrl = "https://rickandmortyapi.com/api/character"
        
        var queryItems: [String: String] = ["page": "\(page)"]
        
        if let filter = filter {
            if let name = filter.name, !name.isEmpty {
                queryItems["name"] = name
            }
            if let status = filter.status, status.lowercased() != "all" {
                queryItems["status"] = status.lowercased()
            }
            if let species = filter.species, species.lowercased() != "all" {
                queryItems["species"] = species.lowercased()
            }
        }
        
        return try await ApiManager.shared.request(baseUrl: baseUrl, method: .get, queryItems: queryItems, responseType: CharacterModel.self)
    }
}

struct CharacterFilter {
    var name: String?
    var status: String?
    var species: String?
}
