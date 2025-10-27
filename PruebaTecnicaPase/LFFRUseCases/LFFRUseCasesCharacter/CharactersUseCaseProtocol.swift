//
//  UseCaseCharacterProtocol.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import Foundation

internal protocol CharactersUseCaseProtocol {
    
    func getCharacters(page: Int, name: String?, status: String?, species: String?) async throws -> [CharacterData]
}
