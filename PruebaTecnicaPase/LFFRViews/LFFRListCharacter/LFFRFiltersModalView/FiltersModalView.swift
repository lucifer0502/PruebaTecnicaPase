//
//  FiltersModalView.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 24/10/25.
//

import SwiftUI

struct FiltersModalView: View {
    
    @ObservedObject var viewModel: CharacterViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // MARK: - Sección Status
                    Section(header: Text("Status")) {
                        ForEach(viewModel.filterStatus, id: \.self) { status in
                            Button {
                                viewModel.selectedStatus = viewModel.selectedStatus == status ? nil : status
                            } label: {
                                HStack {
                                    Text(status)
                                    Spacer()
                                    if viewModel.selectedStatus == status {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Sección Species
                    Section(header: Text("Species")) {
                        ForEach(viewModel.filterSpecies, id: \.self) { species in
                            Button {
                                viewModel.selectedSpecies = viewModel.selectedSpecies == species ? nil : species
                            } label: {
                                HStack {
                                    Text(species)
                                    Spacer()
                                    if viewModel.selectedSpecies == species {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Botón Aplicar filtros
                Button {
                    viewModel.fetchCharacters()
                    dismiss()
                } label: {
                    Text("Aplicar filtros")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Filtros")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
}
