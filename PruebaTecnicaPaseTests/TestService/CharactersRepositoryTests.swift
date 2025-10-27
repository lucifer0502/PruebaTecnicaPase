//
//  CharacterTest.swift
//  PruebaTecnicaPaseTests
//
//  Created by Fernando Flores on 27/10/25.
//

import XCTest
@testable import PruebaTecnicaPase

final class CharactersRepositoryTests: XCTestCase {
    
    //MARK: - Properties
    let repository: CharactersRepositoryProtocol = CharactersRepository()
    
    //MARK: - Test 1
    func testGetCharacters() async throws {
       
        do {
            let result = try await repository.getCharacters(page: 1, filter: nil)
            let countRes = result.results?.count ?? 0
            
            XCTAssertGreaterThan(countRes, 0, "Se esperaban personajes en la página 1")
            
            print("✅ Test sin filtros - Primer personaje: \(result.results?.first?.name ?? "Desconocido")")
            print("Total personajes obtenidos: \(countRes)")
            
        } catch {
            XCTFail("Error al obtener personajes reales: \(error)")
        }
    }

    //MARK: -  Test 2: Filtro por nombre → "Rick"
    func testGetCharactersFilterByName() async throws {
        
        let filter = CharacterFilter(name: "Rick", status: nil, species: nil)
        
        do {
            let result = try await repository.getCharacters(page: 1, filter: filter)
            let countRes = result.results?.count ?? 0
            
            XCTAssertGreaterThan(countRes, 0, "Se esperaban personajes con el filtro 'Rick'")
            
            if let characters = result.results {
                XCTAssertTrue(characters.allSatisfy { $0.name?.contains("Rick") ?? false },
                              "Todos los personajes deberían contener 'Rick' en el nombre")
                
                print("✅ Test filtro por nombre - Primer personaje filtrado: \(characters.first?.name ?? "Desconocido")")
            } else {
                XCTFail("No se recibieron personajes")
            }

        } catch {
            XCTFail("Error al obtener personajes filtrados: \(error)")
        }
    }
    
    //MARK: - Test 3: Filtro por status → "alive"
    func testGetCharactersFilterByStatus() async throws {
        let filter = CharacterFilter(name: nil, status: "alive", species: nil)
        
        do {
            let result = try await repository.getCharacters(page: 1, filter: filter)
            let countRes = result.results?.count ?? 0
            
            XCTAssertGreaterThan(countRes, 0, "Se esperaban personajes vivos")
            
            if let characters = result.results {
                XCTAssertTrue(characters.allSatisfy { $0.status?.lowercased() == "alive" },
                              "Todos los personajes deberían estar vivos")
                print("✅ Test filtro por status - Primer personaje vivo: \(characters.first?.name ?? "Desconocido")")
            } else {
                XCTFail("No se recibieron personajes")
            }
            
        } catch {
            XCTFail("Error al obtener personajes con status 'alive': \(error)")
        }
    }
    
    //MARK: - Test 4: Filtro por especie → "Human"
    func testGetCharactersFilterBySpecies() async throws {
        let filter = CharacterFilter(name: nil, status: nil, species: "Human")
        
        do {
            let result = try await repository.getCharacters(page: 1, filter: filter)
            let countRes = result.results?.count ?? 0
            
            XCTAssertGreaterThan(countRes, 0, "Se esperaban personajes de la especie 'Human'")
            
            if let characters = result.results {
                XCTAssertTrue(characters.allSatisfy { $0.species?.lowercased().contains("human") ?? false },
                              "Todos los personajes deberían ser Humanos")

                print("✅ Test filtro por especie - Primer personaje humano: \(characters.first?.name ?? "Desconocido")")
            } else {
                XCTFail("No se recibieron personajes")
            }
            
        } catch {
            XCTFail("Error al obtener personajes de la especie 'Human': \(error)")
        }
    }
    
    //MARK: - Test 5: Búsqueda sin resultados → nombre inexistente "FffffNonExistent"
    func testGetCharactersNoResults() async throws {
        
        let filter = CharacterFilter(name: "FffffNonExistent", status: nil, species: nil)
        
        do {
            let result = try await repository.getCharacters(page: 1, filter: filter)
            let countRes = result.results?.count ?? 0
            
            XCTAssertEqual(countRes, 0, "No se deberían obtener resultados para un nombre inexistente")
            print("✅ Test sin resultados - Total personajes: \(countRes)")
            
        } catch {
            print("⚠️ Test sin resultados - Error esperado: \(error)")
        }
    }
}
