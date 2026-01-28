//
//  Book.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import Foundation

enum BookListType: String, CaseIterable {
    case favourite
    case wantToRead
    case finished
    
    var title: String {
            switch self {
            case .favourite: return "Favourite"
            case .wantToRead: return "Want to read"
            case .finished: return "Finished"
            }
        }
}


struct Book {
    let id: String
    let title: String
    let authors: String
    let description: String
    let pageCount: Int
    let buyLink: URL?
    let imageLinks: URL?
    let categories: String
    let publishedDate: Date?
    var listTypes: Set<BookListType>
}

extension Book {
    init(dto: BookItem) {
        self.id = dto.id
        self.title = dto.volumeInfo.title
        self.authors = dto.volumeInfo.authors?.joined(separator: ", ") ?? "—"
        self.description = dto.volumeInfo.description ?? ""
        self.pageCount = dto.volumeInfo.pageCount ?? 0
        self.buyLink = URL(string: dto.saleInfo?.buyLink ?? "")
        self.categories = dto.volumeInfo.categories?.joined(separator: ", ") ?? "-"
        self.publishedDate = PublishedDateParser.parse(dto.volumeInfo.publishedDate) ////
        self.listTypes = []
        
        if let urlString = dto.volumeInfo.imageLinks?.thumbnail {
            let httpsString = urlString.replacingOccurrences(of: "http://", with: "https://")
            if let encodedString = httpsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedString) {
                self.imageLinks = url
            } else {
                self.imageLinks = nil
            }
        } else {
            self.imageLinks = nil
        }
    }
}




