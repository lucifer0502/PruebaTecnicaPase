//
//  FavoriteViewModel.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 26/10/25.
//

import Foundation


final class FavoriteViewModel: ObservableObject{
    
    @Published var favorites: [CharacterData] = []
    
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    func fetchFavorites() {
        let savedCharacters: [CharacterData] = CoreDataManager.shared.fetchAll(CharacterData.self)
        favorites = savedCharacters
        print(savedCharacters)
    }
    
    func deleteFavorite(character: CharacterData) {
        guard let id = character.id else { return }
        
        do {
            try CoreDataManager.shared.delete(CharacterData.self, id: "\(id)")
            
            if let index = favorites.firstIndex(where: { $0.id == character.id }) {
                favorites.remove(at: index)
            }
            
        } catch {
            self.errorMessage = "No se pudo eliminar el favorito: \(error.localizedDescription)"
            self.showErrorAlert = true
        }
    }
}


