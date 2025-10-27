//
//  SearchBar.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import SwiftUI

// Vista de búsqueda
struct SearchBar: View {
    @Binding var searchQuery: String
    
    var body: some View {
        TextField("Search by name...", text: $searchQuery)
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding([.horizontal, .top])
    }
}
