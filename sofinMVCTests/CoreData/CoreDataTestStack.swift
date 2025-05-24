//
//  CoreDataTestStack.swift
//  sofinMVC
//
//  Created by Natália Arantes on 24/05/25.
//

import CoreData
@testable import sofinMVC

class CoreDataTestStack {
    static func mockContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "SofinDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Erro ao carregar store em memória: \(error.localizedDescription)")
            }
        }
        
        return container.viewContext
    }
}
