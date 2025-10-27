//
//  MapsViewModel.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 24/10/25.
//

import SwiftUI
import MapKit

final class MapsViewModel: ObservableObject{
    
    @Published var locations: [RandomLocation] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), 
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    func generateRandomLocations(count: Int = 1) {
        var newLocations: [RandomLocation] = []
        for _ in 0..<count {
            let lat = Double.random(in: 19.25...19.55)
            let lon = Double.random(in: (-99.35)...(-99.05))
            let loc = RandomLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            newLocations.append(loc)
        }
        locations = newLocations
    }
    
    struct RandomLocation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}


