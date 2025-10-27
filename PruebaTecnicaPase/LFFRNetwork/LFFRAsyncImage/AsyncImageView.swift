//
//  AsyncImage.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import SwiftUI

struct AsyncImageView: View {
    
    let url : String
    
    var body: some View {
        
        AsyncImage(url: URL(string: url)){ phase in
            if let image = phase.image{
                image
                    .resizable()
                    .scaledToFit()
            }else if phase.error != nil{
                Image("imagenError")
                    .resizable()
                    .scaledToFit()
            }else{
                LoadingView()
            }
            
        }
      
    }
}

