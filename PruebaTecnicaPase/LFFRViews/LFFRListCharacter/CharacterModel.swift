//
//  CharacterModel.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import Foundation

// MARK: - Welcome
struct CharacterModel: Codable {
    let info: InfoModel?
    let results: [CharacterData]?
}

struct InfoModel: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Info
struct InfoData: Codable {
    let count, pages: Int?
    let next: String?
}

// MARK: - Result
struct CharacterData: Codable, Identifiable{
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin, location: CharacterLocation?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

struct CharacterLocation: Codable {
    let name: String?
    let url: String?
}


struct EpisodeData: Codable, Identifiable {
    let id: Int?
    let name: String?
    let episode: String?
}
