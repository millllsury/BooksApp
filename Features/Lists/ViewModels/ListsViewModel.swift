//
//  FavouritesViewModel.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 19/01/2026.
//


import Foundation

protocol ListsViewModelProtocol {
    var sections: [BookListType] { get }
    var onBooksChanged: (() -> Void)? { get set }
    var onShowBookDetails: ((BookDetailsViewModel) -> Void)? { get set }
    
    func load()
    func books(in section: Int) -> [Book]
    func title(for section: Int) -> String
    func selectBook(_ book: Book)
}

class ListsViewModel: ListsViewModelProtocol {

    private let repository: DefaultRepositoryProtocol

    private var allBooks: [BookListType: [Book]] = [:]

    private(set) var sections: [BookListType] = [] {
        didSet { onBooksChanged?() }
    }

    var onBooksChanged: (() -> Void)?
    var onShowBookDetails: ((BookDetailsViewModel) -> Void)?

    init(repository: DefaultRepositoryProtocol) {
        self.repository = repository
    }

    func load() {
        var newSections: [BookListType] = []
        var newBooks: [BookListType: [Book]] = [:]

        for type in BookListType.allCases {
            let books = repository.fetchAll(for: type)
            if !books.isEmpty {
                newSections.append(type)
                newBooks[type] = books
            }
        }

        self.allBooks = newBooks
        self.sections = newSections
    }

    func books(in section: Int) -> [Book] {
        let type = sections[section]
        return allBooks[type] ?? []
    }

    func title(for section: Int) -> String {
        sections[section].title
    }

    func selectBook(_ book: Book) {
        let detailsVM = BookDetailsViewModel(
            book: book,
            defaultRepository: repository
        )
        onShowBookDetails?(detailsVM)
    }
}
