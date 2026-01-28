//
//  MainTabBarController.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 19/01/2026.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let storage: RealmStorageEngine
    private let repository: DefaultRepositoryProtocol
    private let bookService: BookServiceProtocol
    
    init() {
        self.storage = RealmStorageEngine()
        self.repository = DefaultRepository(storage: storage)
        self.bookService = BookService()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    func setUpTabs() {
        
        let homeNav = makeHomeModule()
        let homeTabBarTitle = String(localized: "homeTabBarName")
        homeNav.tabBarItem = UITabBarItem(
            title: homeTabBarTitle,
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        
        let favouritesNav = makeListModule()
        favouritesNav.tabBarItem = UITabBarItem(
            title: String(localized: "listsTabBarTitle"),
            image: UIImage(systemName: "books.vertical"),
            tag: 1
        )
        
        viewControllers = [homeNav, favouritesNav]
    }
    
    
    private func makeHomeModule() -> UIViewController {
        let vm = HomeViewModel(
            bookService: bookService,
            defaultRepository: repository)
        let vc = HomeViewController(viewModel: vm)
        return UINavigationController(rootViewController: vc)
    }
    
    private func makeListModule() -> UIViewController {
        let vm = ListsViewModel(repository: repository)
        let listVC = ListsTableViewController(viewModel: vm)
        return UINavigationController(rootViewController: listVC)
    }

}
