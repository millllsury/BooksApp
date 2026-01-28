//
//  BookService.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import Foundation

enum BooksRequest {
    case search(String)
    case featured
}

protocol BookServiceProtocol: AnyObject {
    func fetchBooks(request: BooksRequest, completion: @escaping ([Book]) -> Void)
}


final class BookService: BookServiceProtocol {
    
    let baseURL = "https://www.googleapis.com/books/v1/volumes"
    private let apiKey = "AIzaSyAPfGk84ah1yUrirfJ0XyKP2QXQfIF8aDI"

    func fetchBooks(request: BooksRequest, completion: @escaping ([Book]) -> Void) {
        guard let url = makeURL(for: request) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(error)
                return
            }
            
            guard let data else { return }
            let books = self.parseJSON(data)
            
            DispatchQueue.main.async {
                completion(books)
            }
        }.resume()
    }

    private func parseJSON(_ data: Data) -> [Book] {
        do {
            let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
            return decoded.items?.map { Book(dto: $0) } ?? []
        } catch {
            print(error)
            return []
        }
    }

    private func makeURL(for request: BooksRequest) -> URL? {
        var components = URLComponents(string: baseURL)

        let items = baseQueryItems() + queryItems(for: request)
        components?.queryItems = items

        return components?.url
    }

    private func baseQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "maxResults", value: "20"),
            URLQueryItem(name: "key", value: apiKey)
        ]
    }
    
    private func queryItems(for request: BooksRequest) -> [URLQueryItem] {
        switch request {
        case .search(let text):
            return [
                URLQueryItem(name: "q", value: text)
            ]

        case .featured:
            return [
                URLQueryItem(name: "q", value: "subject:fiction"),
                URLQueryItem(name: "langRestrict", value: "en")
            ]
        }
    }
}
