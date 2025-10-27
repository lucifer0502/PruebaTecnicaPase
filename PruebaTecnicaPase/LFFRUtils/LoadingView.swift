//
//  LoadingView.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 24/10/25.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var rotationAngle: Double = 0.0
    @State private var timer = Timer.publish(every: 0.014, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("pase") 
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .rotationEffect(.degrees(rotationAngle))
                .onReceive(timer) { _ in
                    rotationAngle += 5
                    if rotationAngle >= 360 { rotationAngle = 0 }
                }
        }
    }
}
