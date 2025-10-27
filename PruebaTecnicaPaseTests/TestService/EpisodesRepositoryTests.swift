//
//  EpisodesTest.swift
//  PruebaTecnicaPaseTests
//
//  Created by Fernando Flores on 27/10/25.
//

import XCTest
@testable import PruebaTecnicaPase

final class EpisodesRepositoryTests: XCTestCase {
    
    //MARK: - Properties
    private var repository: EpisodesRepository = EpisodesRepository()
    
    // MARK: - Test 1: Obtener varios episodios
    func testGetMultipleEpisodes() async throws {
        do {
            
            let result = try await repository.getEpisodes(from: "1,2,3")
            
            XCTAssertFalse(result.isEmpty, "Se esperaban episodios al solicitar IDs múltiples")
            XCTAssertEqual(result.count, 3, "Deberían obtenerse exactamente 3 episodios")
            
            print("✅ Test múltiple - Episodios obtenidos:")
            result.forEach { print("   • \($0.name ?? "Desconocido") (ID: \($0.id ?? 0))") }
            
        } catch {
            XCTFail("❌ Error al obtener múltiples episodios: \(error)")
        }
    }
    
    
    // MARK: - Test 2: Obtener un solo episodio
    func testGetSingleEpisode() async throws {
        do {
            let result = try await repository.getEpisodes(from: "1")
            
            XCTAssertEqual(result.count, 1, "Se esperaba un solo episodio en la respuesta")
            XCTAssertEqual(result.first?.id, 1, "El episodio devuelto debería tener ID = 1")
            
            print("✅ Test único - Episodio: \(result.first?.name ?? "Desconocido")")
            
        } catch {
            XCTFail("❌ Error al obtener un solo episodio: \(error)")
        }
    }
    
    
    // MARK: - Test 3: Manejo de error (episodio inexistente)
    func testGetInvalidEpisode() async throws {
        do {
            _ = try await repository.getEpisodes(from: "999999")
            XCTFail("❌ No se esperaba obtener episodios válidos con ID inexistente")
        } catch {
            print("✅ Test error - Manejo correcto de episodio inexistente: \(error)")
        }
    }
}
