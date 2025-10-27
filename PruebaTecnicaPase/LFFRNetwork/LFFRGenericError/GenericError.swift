//
//  GenericError.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import SwiftUI

struct GenericError: Error, Decodable {
    
    let codigo:String?
    let error: String?
}
