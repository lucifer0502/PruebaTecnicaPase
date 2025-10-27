//
//  FilterView.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import SwiftUI

// Vista de filtros
struct FilterView: View {
    @Binding var filterStatus: String
    @Binding var filterSpecies: String
    
    var body: some View {
        HStack {
            Picker("Status", selection: $filterStatus) {
                Text("All").tag("All")
                Text("Alive").tag("Alive")
                Text("Dead").tag("Dead")
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            
            Picker("Species", selection: $filterSpecies) {
                Text("All").tag("All")
                Text("Human").tag("Human")
                Text("Alien").tag("Alien")
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
        }
        .padding([.horizontal, .top])
    }
}
