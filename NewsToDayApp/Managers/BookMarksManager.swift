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
        category: String,
        creator: String,
        descrition: String,
        isFavorite: Bool,
        userID: String
    )
    func fetchBookmarks() -> [BookmarkEntity]
    func deleteBookmark(id: String)
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
    
    private let viewContext: NSManagedObjectContext
    
    // MARK: Initialization
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD Methods
    func saveBookmark(
        id: String,
        title: String,
        link: String,
        category: String,
        creator: String,
        descrition: String,
        isFavorite: Bool,
        userID: String
    ) {
        let bookmark = BookmarkEntity(context: viewContext)
        bookmark.id = id
        bookmark.title = title
        bookmark.link = link
        bookmark.category = category
        bookmark.creator = creator
        bookmark.descriptionArticle = descrition
        bookmark.isFavirite = isFavorite
        bookmark.userId = userID
        saveContext()
    }
    
    // Read
    func fetchBookmarks() -> [BookmarkEntity] {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch bookmarks: \(error.localizedDescription)")
            return []
        }
    }
    
    
    // Delete
    func deleteBookmark(id: String) {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try viewContext.fetch(request)
            if let bookmark = results.first {
                viewContext.delete(bookmark)
                saveContext()
            }
        } catch {
            print("Failed to delete bookmark: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Save Context
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
