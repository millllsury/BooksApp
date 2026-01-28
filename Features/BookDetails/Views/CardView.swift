//
//  File.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 27/01/2026.
//

import UIKit

final class CardView: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
