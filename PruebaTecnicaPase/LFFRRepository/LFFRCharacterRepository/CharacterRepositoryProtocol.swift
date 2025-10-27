//
//  CharacterRepositoryProtocol1.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//


import Foundation

internal protocol CharactersRepositoryProtocol {
    
    init()
    
    func getCharacters(page: Int, filter: CharacterFilter?) async throws -> CharacterModel
}
