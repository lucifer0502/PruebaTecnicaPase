//
//  UseCaseCharacter.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//



import Foundation


internal final class CharactersUseCase: CharactersUseCaseProtocol {
    
    private let charactersRepository: CharactersRepositoryProtocol
    
    init(charactersRepository: CharactersRepositoryProtocol = CharactersRepository()) {
        self.charactersRepository = charactersRepository
    }
    
    func getCharacters(page: Int, name: String?, status: String?, species: String?) async throws -> [CharacterData] {
        
        let filter = CharacterFilter(name: name, status: status, species: species)
        
        let response = try await charactersRepository.getCharacters(page: page, filter: filter)
        
        guard let charactersArray = response.results else {
            throw GenericError(codigo: "", error: "No se encontraron personajes")
        }
        
        return charactersArray
    }
}
