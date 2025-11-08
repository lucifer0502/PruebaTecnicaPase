//
//  CoreData.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 26/10/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Guardar un modelo genérico
    func save<T: Codable & Identifiable>(_ object: T) {
        do {
            let entity = FavoriteCharacter(context: context)
            
            if let anyId = object.id as? CustomStringConvertible {
                entity.id = String(describing: anyId)
            } else {
                entity.id = UUID().uuidString
            }
            
            entity.type = String(describing: T.self)
            entity.data = try JSONEncoder().encode(object)
            try context.save()
            
            print("\(T.self) guardado correctamente con id: \(entity.id ?? "nil")")
        } catch {
            print(" Error al guardar \(T.self): \(error)")
        }
    }
    
    // MARK: - Obtener todos los objetos de un tipo
    func fetchAll<T: Codable>(_ type: T.Type) -> [T] {
        let request: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", String(describing: T.self))
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { entity in
                guard let data = entity.data else { return nil }
                
                return try? JSONDecoder().decode(T.self, from: data)
                
            }
        } catch {
            print(" Error al obtener objetos de tipo \(T.self): \(error)")
            return []
        }
    }
    
    // MARK: - Eliminar un personaje por id
    func delete<T: Identifiable>(_ type: T.Type, id: String) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteCharacter")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            
            if let result = try context.fetch(request).first as? NSManagedObject {
                context.delete(result)
                try context.save()
                print("Objeto eliminado con id: \(id)")
            } else {
                print("No se encontró ningún objeto con id: \(id)")
            }
        } catch {
            print("Error al eliminar \(T.self): \(error)")
            throw error
        }
    }
    
}
