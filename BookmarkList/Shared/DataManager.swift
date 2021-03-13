//
//  DataManager.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import UIKit
import CoreData




class DataManager {
    static let shared = DataManager()
    
    var items:[Bookmark] {
        return self.fetchBookmark().map { (target) in
            return Bookmark(id:Int16(target.id), name: target.name ?? "", thumbnail: target.thumbnail ?? "", imagePath: target.imagePath ?? "", subject: target.subject ?? "", price: Int64(target.price), rate: target.rate, rateTime: target.rateTime)
        }
    }
    
    
    private init() { }
    
    var container: NSPersistentContainer?
    
    var mainContext: NSManagedObjectContext {
        guard let context = container?.viewContext else {
            fatalError()
        }
        
        return context
    }
    
    
    func setup(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container?.loadPersistentStores(completionHandler: { (desc, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
        })
    }
    
    
    func saveMainContext() {
        mainContext.perform {
            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
}
