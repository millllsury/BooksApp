//
//  HomeViewController.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import UIKit

class HomeViewController: UITableViewController {
    
    let homeViewModel: HomeViewModelProtocol
    let searchResultsVC = SearchResultsViewController() //деталь реализации экрана, а не логика приложения.
    
    init(viewModel: HomeViewModelProtocol) {
        self.homeViewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Books"
        setupView()
        setupBindings()
        setupSearchController()
        homeViewModel.loadFeaturedBooks()
    }
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        let nib = UINib(nibName: "BookTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BookTableViewCell")
    }
    
    
    private func setupBindings() {
        homeViewModel.onBooksChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
        homeViewModel.onSuggestionsChanged = { [weak self] suggestions in
            self?.searchResultsVC.booksToShow = suggestions
        }
        
        homeViewModel.onShowBookDetails = { [weak self] detailsVM in
            let detailsVC = BookDetailsViewController(viewModel: detailsVM)
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
        searchResultsVC.onBookSelected = { [weak self] book in
            self?.homeViewModel.selectBook(book)
        }
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultsVC)
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = "Search book"
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.mainBooks.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BookTableViewCell",
            for: indexPath
        ) as! BookTableViewCell
        
        let item = homeViewModel.mainBooks[indexPath.row]
        
        cell.title.text = item.title
        cell.pages.text = String(item.pageCount)
        cell.bookAuthor.text = item.authors
        cell.bookImage.loadImage(from: item.imageLinks, placeholder: UIImage(named: "placeholder"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = homeViewModel.mainBooks[indexPath.row]
        homeViewModel.selectBook(selectedBook)
    }
}



extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        homeViewModel.showBooksSuggestions(query)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        homeViewModel.searchBooks(searchBar.text ?? "")
        searchController.isActive = false
    }
}

