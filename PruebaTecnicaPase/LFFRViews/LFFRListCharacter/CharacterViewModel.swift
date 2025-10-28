//
//  ListCharacterViewModel.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import Foundation

final class CharacterViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var charactersArray: [CharacterData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var currentPage: Int = 1
    @Published var showFavoriteList = false

    
    // MARK: - Filters
    @Published var searchQuery: String = ""
    @Published var selectedStatus: String?
    @Published var selectedSpecies: String?
    @Published var filterStatus: [String] = []
    @Published var filterSpecies: [String] = []
    
    // MARK: - Dependencies
    private let charactersUseCase: CharactersUseCaseProtocol
    
    // MARK: - Initializer
    init(charactersUseCase: CharactersUseCaseProtocol = CharactersUseCase()) {
        self.charactersUseCase = charactersUseCase
    }
    
    // MARK: - Public Methods
    func fetchCharacters() {
        isLoading = true
        
        Task { @MainActor in
            do {
                let response = try await charactersUseCase.getCharacters(page: currentPage, name: searchQuery.isEmpty ? nil : searchQuery, status: selectedStatus, species: selectedSpecies)
                setupResponse(response)
                
            } catch let error as GenericError {
                print("Código: \(error.codigo ?? ""), Mensaje: \(error.error ?? "" )")
                charactersArray.removeAll()
                self.errorMessage = "Código: \(error.codigo ?? ""), Mensaje: \(error.error ?? "")"
                self.showErrorAlert = true
            }
            isLoading = false
        }
    }
    
    private func setupResponse(_ response: [CharacterData]){
        charactersArray.removeAll()
        charactersArray = response
        filterStatus = Array(Set(response.compactMap { $0.status }))
        filterSpecies = Array(Set(response.compactMap { $0.species }))
        searchQuery = ""
        selectedStatus = nil
        selectedSpecies = nil
    }
    
    func userAuthenticator(){
            BiometricAuthenticator.authenticateUser { success in
                if success {
                    self.showFavoriteList.toggle()
                } else {
                    self.errorMessage = "Ocurrio un error al autenticar"
                    self.showErrorAlert = true
                }
            }
        }
}
