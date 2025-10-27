//
//  MapsView.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 24/10/25.
//

import SwiftUI
import MapKit


struct MapsView: View {
    
    @StateObject var viewModel = MapsViewModel()
    
    var body: some View {
        Map(position: .constant(.region(viewModel.region))) {
            ForEach (viewModel.locations) { location in
                Marker("Punto", coordinate: location.coordinate)
            }
        }
        .onAppear {
            viewModel.generateRandomLocations()
        }
        .ignoresSafeArea()
    }
}
