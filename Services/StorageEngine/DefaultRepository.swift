//
//  FavouritesRepository.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 21/01/2026.
//

import RealmSwift


protocol DefaultRepositoryProtocol {
    func add(book: Book)
    func remove(book: Book)
    func toggleListType(bookId: String, type: BookListType)
    func isTypeInList(bookId: String, type: BookListType) -> Bool
    func fetchAll(for listType: BookListType) -> [Book]
    func existsInStorage(bookId: String) -> Bool
    var onBooksChanged: (() -> Void)? { get set }
}


final class DefaultRepository: DefaultRepositoryProtocol {
    
    var onBooksChanged: (() -> Void)?

    private let storage: StorageEngine

    init(storage: StorageEngine) {
        self.storage = storage
    }
    
    func add(book: Book) {
        let object = BookObject(book: book)
        print("BookObject \(object) has been added.")
        storage.save(object)
    }

    func remove(book: Book) {
        guard let object = storage.fetchById(BookObject.self, id: book.id) else { return }
        print("BookObject \(object) has been removed.")
        storage.delete(object)
       
    }

    func fetchAll(for listType: BookListType) -> [Book] {
        storage
            .fetch(BookObject.self)
            .filter { $0.listTypes.contains(listType.rawValue) }
            .map { $0.toDomain() }
    }
    
    func addToList(bookId: String, type: BookListType) {
        storage.update(BookObject.self, id: bookId) { obj in
            let raw = type.rawValue
            if !obj.listTypes.contains(raw) {
                obj.listTypes.append(raw)
            }
            print("The list type \(raw) has been added to book object \(obj) ")
        }
        
    }
    
    func removeFromList(bookId: String, type: BookListType) {
        storage.update(BookObject.self, id: bookId) { obj in
            let raw = type.rawValue
            if let index = obj.listTypes.firstIndex(of: raw) {
                obj.listTypes.remove(at: index)
            }
            print("The list type \(raw) has been removed from book object \(obj) ")
        }
    }
    
    func toggleListType(bookId: String, type: BookListType) {
        if isTypeInList(bookId: bookId, type: type) {
            removeFromList(bookId: bookId, type: type)
        } else {
            addToList(bookId: bookId, type: type)
        }
    }

    
    func isTypeInList(bookId: String, type: BookListType) -> Bool {
        guard let obj = storage.fetchById(BookObject.self, id: bookId) else { return false }
        return obj.listTypes.contains(type.rawValue)
    }
    
    func existsInStorage(bookId: String) -> Bool {
        return storage.fetchById(BookObject.self, id: bookId) != nil
    }
    
    

}
