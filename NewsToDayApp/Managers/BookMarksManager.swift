//
//  BookMarksManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 27.10.2024.
//

import Foundation
import CoreData

protocol IBookMarks {
    func saveBookmark(
        id: String,
        title: String,
        link: String,
        imageURL: String,
        category: String,
        creator: String,
        descrition: String,
        isFavorite: Bool,
        userID: String
    )
    func fetchBookmarks() -> [BookmarkEntity]
    func deleteBookmark(id: String)
    func deleteAllBookmarks()
}

final class BookMarksManager: IBookMarks {
    // MARK: - Properties
    static let shared = BookMarksManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookmarkEntity")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var privateContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - CRUD Methods
    func fetchBookmarks() -> [BookmarkEntity] {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch bookmarks: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveBookmark(
        id: String,
        title: String,
        link: String,
        imageURL: String,
        category: String,
        creator: String,
        descrition: String,
        isFavorite: Bool,
        userID: String
    ) {
        privateContext.perform { [weak self] in
            guard let self else { return }
            
            let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@ AND userId == %@", id, userID)
            
            do {
                let existingBookmark = try self.privateContext.fetch(request).first
                
                if existingBookmark == nil {
                    let bookmark = BookmarkEntity(context: self.privateContext)
                    bookmark.id = id
                    bookmark.title = title
                    bookmark.link = link
                    bookmark.imageURL = imageURL
                    bookmark.category = category
                    bookmark.creator = creator
                    bookmark.descriptionArticle = descrition
                    bookmark.userId = userID
                    
                    self.saveContext()
                } else {
                    print("Bookmark already exists for this user.")
                }
            } catch {
                print("Failed to fetch bookmark for duplicate check: \(error)")
            }
        }
    }
    
    func deleteBookmark(id: String) {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        privateContext.perform { [weak self] in
            guard let self else { return }
            if let bookmark = try? self.privateContext.fetch(request).first {
                self.privateContext.delete(bookmark)
                self.saveContext()
            }
        }
    }
    
    func deleteAllBookmarks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookmarkEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try privateContext.execute(deleteRequest)
            saveContext()
            print("All bookmarks have been deleted successfully.")
        } catch {
            print("Failed to delete bookmarks: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Save Context
    private func saveContext() {
        do {
            if privateContext.hasChanges {
                try privateContext.save()
                
                viewContext.performAndWait {
                    do {
                        try viewContext.save()
                        viewContext.refreshAllObjects()
                    } catch {
                        print("Failed to save viewContext: \(error)")
                    }
                }
            }
        } catch {
            print("Failed to save privateContext: \(error)")
        }
    }
}
