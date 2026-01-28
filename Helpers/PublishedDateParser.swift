//
//  PublishedDateParser.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 23/01/2026.
//

import Foundation

enum PublishedDateParser {

    static func parse(_ string: String?) -> Date? {
        guard let string else { return nil }

        let formats = [
            "yyyy-MM-dd",
            "yyyy-MM",
            "yyyy"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: string) {
                return date
            }
        }

        return nil
    }
}
