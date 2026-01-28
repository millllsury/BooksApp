//
//  BookDetailsViewModel.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 19/01/2026.
//

import Foundation

protocol BookDetailsViewModelProtocol {

    var titleText: String { get }
    var authorText: String { get }
    var descriptionText: String { get }
    var imageURL: URL? { get }
    var pageAmount: String { get }
    var buyLink: URL? { get }
    var categories: String { get }
    var publishedYearText: String { get }

    var isFavourite: Bool { get }
    var isWantToRead: Bool { get }

    func toggleFav()
    func toggleWantToRead()
    func cleanupIfNeeded()

    var onFavoriteChanged: ((Bool) -> Void)? { get set }
    var onWantToReadChanged: ((Bool) -> Void)? { get set }
}


class BookDetailsViewModel: BookDetailsViewModelProtocol {
    
    private let book: Book
    private let repository: DefaultRepositoryProtocol
    var onFavoriteChanged: ((Bool) -> Void)?
    var onWantToReadChanged: ((Bool) -> Void)?
    
    
    init(book: Book, defaultRepository: DefaultRepositoryProtocol) {
        self.book = book
        self.repository = defaultRepository
        print("DETAILS VM INIT FOR:", book.id)
    }
    
    var id: String { book.id }
    var titleText: String { book.title }
    var authorText: String {  book.authors }
    var descriptionText: String { book.description }
    var imageURL: URL? { book.imageLinks }
    var pageAmount: String { String(book.pageCount) }
    var buyLink: URL? { book.buyLink }
    var categories: String { book.categories }
    var publishedYearText: String {
        guard let date = book.publishedDate else {
            return "—"
        }
        let year = Calendar.current.component(.year, from: date)
        return "\(year)"
    }
    
    private var isInRepository: Bool {
        repository.existsInStorage(bookId: book.id)
    }
    
    private func addToRepository() {
        repository.add(book: book)
    }
    
    private func removeFromRepository() {
        repository.remove(book: book)
    }
    
    private func toggleList(type: BookListType) {
        if !isInRepository {
            addToRepository()
        }
        repository.toggleListType(bookId: book.id, type: type)
    
        onFavoriteChanged?(isFavourite)
        onWantToReadChanged?(isWantToRead)
    }
    
    var isFavourite: Bool {
        repository.isTypeInList(bookId: book.id, type: .favourite)
    }
    
    var isWantToRead: Bool {
        repository.isTypeInList(bookId: book.id, type: .wantToRead)
    }
    
    func toggleFav() {
        toggleList(type: .favourite)
    }
    
    func toggleWantToRead() {
        toggleList(type: .wantToRead)
    }
    
    func cleanupIfNeeded() {
        if !isFavourite && !isWantToRead {
            removeFromRepository()
        }
    }

}
