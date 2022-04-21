//
//  StorageManager.swift
//  TaskList
//
//  Created by Aleksandr F. on 20.04.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchData(_ completion: @escaping ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
            completion(taskList)
        } catch {
            print(error)
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete(_ task: Task) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: persistentContainer.viewContext)
        task.title = taskName
        completion(task)
        saveContext()
    }
}
