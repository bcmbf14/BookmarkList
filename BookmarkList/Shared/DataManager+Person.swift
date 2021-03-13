//
//  DataManager+Person.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Foundation
import CoreData

extension DataManager {
    func createPerson(mark: Bookmark, completion: (() -> ())? = nil) {
        mainContext.perform {
            
            let newBookmark = BookmarkEntity(context: self.mainContext)
            newBookmark.id = Int16(mark.id)
            newBookmark.imagePath = mark.imagePath
            newBookmark.name = mark.name
            newBookmark.price = Int64(mark.price)
            newBookmark.rate = Double(mark.rate ?? 0.0)
            newBookmark.rateTime = Date()
            newBookmark.subject = mark.subject
            newBookmark.thumbnail = mark.thumbnail
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    func fetchBookmark(sort: Sort = .time) -> [BookmarkEntity] {
        var list = [BookmarkEntity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
            
            switch sort {
            case .rate :
                let sortByRate = NSSortDescriptor(key: #keyPath(BookmarkEntity.rate), ascending: false)
                request.sortDescriptors = [sortByRate]
            case .time :
                let sortByTime = NSSortDescriptor(key: #keyPath(BookmarkEntity.rateTime), ascending: false)
                request.sortDescriptors = [sortByTime]
            }
            
            do {
                list = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
        
        return list
    }
    
    
    func delete(entity: BookmarkEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}



