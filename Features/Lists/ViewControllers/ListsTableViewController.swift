//
//  FavouritesTableViewController.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 19/01/2026.
//

import UIKit

class ListsTableViewController: UITableViewController {

    var listsVM: ListsViewModelProtocol
    
    private lazy var emptyStateView = EmptyStateView()

    
    init(viewModel: ListsViewModelProtocol) {
        self.listsVM = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My books"
        let nib = UINib(nibName: "BookTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BookTableViewCell")
        view.backgroundColor = .secondarySystemBackground
        tableView.backgroundView = emptyStateView
        tableView.separatorStyle = .none
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listsVM.load()
    }
    
    func setupBindings() {
        listsVM.onBooksChanged = { [weak self] in
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        
        listsVM.onShowBookDetails = { [weak self] detailsVM in
            let detailsVC = BookDetailsViewController(viewModel: detailsVM)
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = listsVM.sections.isEmpty

        emptyStateView.isHidden = !isEmpty
        tableView.separatorStyle = isEmpty ? .none : .singleLine
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        listsVM.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listsVM.books(in: section).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        listsVM.title(for: section)
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BookTableViewCell",
            for: indexPath
        ) as! BookTableViewCell
        
        let item = listsVM.books(in: indexPath.section)[indexPath.row]

        cell.title.text = item.title
        cell.pages.text = String(item.pageCount)
        cell.bookAuthor.text = item.authors
        cell.bookImage.loadImage(from: item.imageLinks, placeholder: UIImage(named: "placeholder"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = listsVM.books(in: indexPath.section)[indexPath.row]
        listsVM.selectBook(selectedBook)
    }

}
