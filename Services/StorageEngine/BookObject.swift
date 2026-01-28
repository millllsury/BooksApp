//
//  BookObject.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 21/01/2026.
//

import RealmSwift
import Foundation


final class BookObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var authors: String
    @Persisted var imageURL: String?
    @Persisted var averageRating: Double
    @Persisted var buyLink: String?
    @Persisted var pages: Int
    @Persisted var categories: String
    @Persisted var published: Date?
    @Persisted var bookDescription: String
    @Persisted var listTypes: List<String>
}

// to database
extension BookObject {
    convenience init(book: Book) {
        self.init()
        self.id = book.id
        self.title = book.title
        self.authors = book.authors
        self.imageURL = book.imageLinks?.absoluteString
        self.buyLink = book.buyLink?.absoluteString
        self.pages = book.pageCount
        self.categories = book.categories
        self.published = book.publishedDate
        self.bookDescription = book.description
        self.listTypes.removeAll()
        let types = book.listTypes
        self.listTypes.append(objectsIn: types.map { $0.rawValue })
    }
}

// from database
extension BookObject {
    func toDomain() -> Book {
        
        let typesSet = Set(listTypes.compactMap { BookListType(rawValue: $0) })
        
        return Book(
            id: id,
            title: title,
            authors: authors,
            description: bookDescription,
            pageCount: pages,
            buyLink: buyLink.flatMap(URL.init),
            imageLinks: imageURL.flatMap(URL.init),
            categories: categories,
            publishedDate: published,
            listTypes: typesSet
        )
    }
}
