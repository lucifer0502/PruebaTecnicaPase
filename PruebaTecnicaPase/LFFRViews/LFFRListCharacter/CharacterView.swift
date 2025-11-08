//
//  CharacterView.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//


import SwiftUI
import LocalAuthentication

struct CharacterView: View {
    
    @StateObject var viewModel = CharacterViewModel()
    @StateObject var navigationManager = NavigationManger()
    @State private var showFilters = false
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                
                TextField("Buscar por nombre...", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onSubmit {
                        viewModel.resetAllAndFetch(refreshable: false)
                    }
                
                // MARK: - Character list
                if viewModel.charactersArray.isEmpty {
                    VStack(spacing: 20) {
                        Image("morty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                        
                        Text("No se encontraron personajes")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()
                    }
                    
                } else {
                    List(viewModel.charactersArray) { character in
                        Button {
                            navigationManager.selectedCharacter = character
                            navigationManager.navigate(to: .DetailCharacter)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: character.image ?? "")) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } placeholder: {
                                    LoadingView()
                                    
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(character.name ?? "")
                                        .font(.headline)
                                    Text(character.species ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(character.status ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(character.status == "Alive" ? .green : .red)
                                }
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear{
                            viewModel.loadMoreIfNeeded(currentItem: character)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.resetAllAndFetch(refreshable: true)
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                        
                    }
                }
                
            }
            .navigationTitle("Personajes")
            .onAppear {
                if viewModel.charactersArray.isEmpty {
                    viewModel.fetchCharacters(reset: true)
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilters.toggle()
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.userAuthenticator()
                    } label: {
                        Image(systemName: "heart")
                            .imageScale(.large)
                    }
                }
                
            }
            
            .sheet(isPresented: $showFilters) {
                FiltersModalView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showFavoriteList) {
                FavoriteView()
            }
            .navigationDestination(for: DestinationEnum.self) { destination in
                navigationManager.destination(for: destination)
            }
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
