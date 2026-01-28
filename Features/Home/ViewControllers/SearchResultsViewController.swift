//
//  SearchResultsViewController.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 15/01/2026.
//

import UIKit

protocol SearchResultsProtocol {
    var booksToShow: [Book] { get set }
    var onBookSelected: ((Book) -> Void)? { get set }
    func toShowSuggestions(suggestions: [Book])
}

class SearchResultsViewController: UITableViewController, SearchResultsProtocol {
    
    var booksToShow: [Book] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var onBookSelected: ((Book) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        let nib = UINib(nibName: "SuggestionsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SuggestionsTableViewCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksToShow.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SuggestionsTableViewCell",
            for: indexPath
        ) as! SuggestionsTableViewCell

        let item = booksToShow[indexPath.row]
        cell.title.text = item.title
        cell.authorName.text = String(item.authors)
        cell.bookImage.loadImage(from: item.imageLinks, placeholder: UIImage(named: "placeholder"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = booksToShow[indexPath.row]
        onBookSelected?(book)
    }
    
    func toShowSuggestions(suggestions: [Book]) {
        booksToShow = suggestions
    }
    
}

