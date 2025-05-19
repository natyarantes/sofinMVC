//
//  CoreDataManager.swift
//  sofinMVC
//
//  Created by Natália Arantes on 19/05/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "SofinDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Erro ao carregar o container do Core Data: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Erro ao salvar contexto: \(error.localizedDescription)")
            }
        }
    }
}
