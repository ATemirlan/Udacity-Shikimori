//
//  CoreDataStack.swift
//  Shikimori
//
//  Created by Temirlan on 22.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStack {
    
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let dbURL: URL
    internal let persistingContext: NSManagedObjectContext
    internal let backgroundContext: NSManagedObjectContext
    let context: NSManagedObjectContext
    
    static let shared = CoreDataStack(modelName: "ShikimoriDataBase")!
    
    // MARK: Initializers
    
    init?(modelName: String) {
        
        // Assumes the model is in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil
        }
        self.modelURL = modelURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        // Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // Create a persistingContext (private queue) and a child one (main queue)
        // create a context and add connect it to the coordinator
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        // Create a background context child of main context
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        // Add a SQLite store located in the documents folder
        let fm = FileManager.default
        
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.dbURL = docUrl.appendingPathComponent("model.sqlite")
        
        // Options for migration
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("unable to add store at \(dbURL)")
        }
    }
    
    // MARK: Utils
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
    
    func save(anime: Anime) {
        
        if getAnimes(with: true, by: anime.id!) == nil {
            let localAnime = LocalAnime(context: context)
            
            localAnime.aired_on = anime.aired_on as NSDate?
            localAnime.descript = anime.descript
            localAnime.episodes = String(describing: anime.episodes)
            localAnime.episodes_aired = String(describing: anime.episodes_aired)
            localAnime.genres = anime.genres
            localAnime.id = String(describing: anime.id!)
            localAnime.kind = anime.kind
            localAnime.name = anime.name
            localAnime.released_on = anime.released_on as NSDate?
            localAnime.russianName = anime.russianName
            localAnime.status = anime.status
            localAnime.score = anime.score ?? 0.0
            
            if let _ = anime.imageUrl {
                localAnime.imageUrl = String(describing: anime.imageUrl!)
            }
            
            save()
        }
    }
    
    func getAnimes(with usingPredicate: Bool, by animeId: Int?) -> [LocalAnime]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalAnime")
        
        if usingPredicate == true, let _ = animeId {
            let predicate = NSPredicate(format: "id == %@", argumentArray: [String(animeId!)])
            fetchRequest.predicate = predicate
        }
        
        do {
            if let result = try context.fetch(fetchRequest) as? [LocalAnime] {
                return result.count > 0 ? result : nil
            }
        } catch {
            print("Error getting data")
        }
        
        return nil
    }
    
    func getMoc() -> NSManagedObjectContext {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        return privateMOC
    }
    
    func save() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                fatalError("Error while saving main context: \(error)")
            }
            
            // now we save in the background
            self.persistingContext.perform() {
                do {
                    try self.persistingContext.save()
                } catch {
                    fatalError("Error while saving persisting context: \(error)")
                }
            }
        }
    }
    
}
