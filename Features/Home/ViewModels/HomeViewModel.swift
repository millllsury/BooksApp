//
//  HomeViewModel.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var mainBooks: [Book] { get }
    var onBooksChanged: (() -> Void)? { get set }
    var onSuggestionsChanged: (([Book]) -> Void)? { get set }
    var onShowBookDetails: ((BookDetailsViewModel) -> Void)? { get set }

    
    func loadFeaturedBooks()
    func searchBooks(_ text: String)
    func showBooksSuggestions(_ text: String)
    func selectBook(_ book: Book)
}


class HomeViewModel: HomeViewModelProtocol {
    
    var onShowBookDetails: ((BookDetailsViewModel) -> Void)?
    private let bookService: BookServiceProtocol
    private let repository: DefaultRepositoryProtocol
    
    var mainBooks: [Book] = []
    var suggestionBooks: [Book] = []
    var onBooksChanged: (() -> Void)?
    var onSuggestionsChanged: (([Book]) -> Void)?
    
    private var searchWorkItem: DispatchWorkItem?
    
    init(bookService: BookServiceProtocol, defaultRepository: DefaultRepositoryProtocol) {
        self.bookService = bookService
        self.repository = defaultRepository
    }
    
    func loadFeaturedBooks() {
        bookService.fetchBooks(request: .featured) { [weak self] books in
            self?.mainBooks = books
            self?.onBooksChanged?()
        }
    }
    
    func showBooksSuggestions(_ text: String) {
        searchWorkItem?.cancel()
        guard text.count >= 2 else {
            suggestionBooks = []
            onSuggestionsChanged?([])
            return
        }
        let workItem = DispatchWorkItem { [weak self] in
            self?.bookService.fetchBooks(request: .search(text)) { [weak self] books in
                self?.suggestionBooks = books
                self?.onSuggestionsChanged?(books)
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
    }
    
    func searchBooks(_ text: String) {
        guard !text.isEmpty else { return }
        bookService.fetchBooks(request: .search(text)) { [weak self] books in
            self?.mainBooks = books.sorted {
                !$0.description.isEmpty && $1.description.isEmpty
            }
            self?.onBooksChanged?()
        }
    }
    
    
    func selectBook(_ book: Book) {
        let detailsVM = BookDetailsViewModel(
            book: book,
            defaultRepository: repository
        )
        onShowBookDetails?(detailsVM)
    }


    
}
