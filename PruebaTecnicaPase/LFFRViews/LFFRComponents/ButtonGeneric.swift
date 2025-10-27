//
//  ButtonGeneric.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 26/10/25.
//

import SwiftUI

struct ButtonGeneric: View {
    let label: String
    let icon: String
    var isSelected: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(label)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.red : Color.blue)
            .cornerRadius(20)
        }
    }
}
