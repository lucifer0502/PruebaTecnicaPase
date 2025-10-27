//
//  NavigationManager.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 24/10/25.
//

import SwiftUI
import Foundation

class NavigationManger: ObservableObject{
    
    @Published var path: [DestinationEnum] = []
    
    @Published var selectedCharacter: CharacterData? = nil
    
    func navigate(to destination: DestinationEnum) {
        DispatchQueue.main.async {
            self.path.append(destination)
        }
    }
    
    func goBack(levels: Int = 1) {
        DispatchQueue.main.async {
            let countToRemove = min(levels, self.path.count)
            self.path.removeLast(countToRemove)
        }
    }
    
    @ViewBuilder
    func destination(for destination: DestinationEnum) -> some View {
        switch destination {
        case .DetailCharacter:
            DetailCharacter()
                .environmentObject(self)
        case .MapsView:
            MapsView()
                .environmentObject(self)
            
        }
    }
}

