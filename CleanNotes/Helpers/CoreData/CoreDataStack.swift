//
//  CoreDataStack.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private let modelName: String
    private let inMemory: Bool
    
    init(modelName: String = "CleanNotesCoreData", inMemory: Bool = false) {
        self.modelName = modelName
        self.inMemory = inMemory
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType  // Use in-memory store for tests
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { description, error in
            if let error {
                print("Trouble loading Core data store \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("There was trouble saving context \(error.localizedDescription)")
        }
    }
}
