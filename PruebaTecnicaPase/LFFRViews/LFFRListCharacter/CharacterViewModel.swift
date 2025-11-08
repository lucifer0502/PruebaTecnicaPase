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
    @Published var currentPage = 1
    @Published var hasMorePages = true
    @Published var showFavoriteList = false
    @Published var totalPages: Int = 1
    
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
    func fetchCharacters(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        if reset {
            currentPage = 1
            hasMorePages = true
            charactersArray.removeAll()
        }
        
        Task { @MainActor in
            do {
                let response = try await charactersUseCase.getCharacters(page: currentPage, name: searchQuery.isEmpty ? nil : searchQuery, status: selectedStatus,species: selectedSpecies)
                
                totalPages = Constant.pages
                
                setupResponse(response, reset: reset)
                
                if currentPage < totalPages {
                    currentPage += 1
                } else {
                    hasMorePages = false
                }
                
            } catch let error as GenericError {
                self.errorMessage = "Código: \(error.codigo ?? ""), Mensaje: \(error.error ?? "")"
                self.showErrorAlert = true
            }
            
            isLoading = false
        }
    }
    
    private func setupResponse(_ response: [CharacterData], reset: Bool) {
        if reset {
            charactersArray = response
            filterStatus = Array(Set(response.compactMap { $0.status }))
            filterSpecies = Array(Set(response.compactMap { $0.species }))
            
        } else {
            charactersArray.append(contentsOf: response)
        }
        
        hasMorePages = currentPage < totalPages
    }
    
    func loadMoreIfNeeded(currentItem item: CharacterData?) {
        guard !isLoading, let item = item, hasMorePages else { return }
        
        if let lastIndex = charactersArray.firstIndex(where: { $0.id == item.id }),
           lastIndex >= charactersArray.count - 3 {
            fetchCharacters(reset: false)
        }
    }
    
    func resetAllAndFetch(refreshable: Bool) {
        if refreshable {
            searchQuery = ""
        }
        selectedStatus = nil
        selectedSpecies = nil
        fetchCharacters(reset: true)
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
