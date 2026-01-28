//
//  BookResponseDTO.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import Foundation

struct BookResponse: Codable {
    let items: [BookItem]?
}

struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo?
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let pageCount: Int?
    let imageLinks: ImageLink?
    let categories: [String]?
    let averageRating: Double?
    let publishedDate: String?
}

struct SaleInfo: Codable {
    let buyLink: String?
}

struct ImageLink: Codable {
    let thumbnail: String?
}
