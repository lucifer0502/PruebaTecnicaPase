//
//  FavoriteViewModel.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 26/10/25.
//

import Foundation


final class FavoriteViewModel: ObservableObject{
    
    @Published var favorites: [CharacterData] = []
    
    func fetchFavorites() {
        let savedCharacters: [CharacterData] = CoreDataManager.shared.fetchAll(CharacterData.self)
        favorites = savedCharacters
        print(savedCharacters)
    }
    
    func deleteFavorite(character: CharacterData) {
        if let index = favorites.firstIndex(where: { $0.id == character.id }) {
            favorites.remove(at: index)
        }
        
        guard let id = character.id else { return }
        CoreDataManager.shared.delete(CharacterData.self, id: "\(id)")
    }
}


