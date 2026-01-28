//
//  BookDetailsViewController.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 19/01/2026.
//

import UIKit
import SafariServices

class BookDetailsViewController: UIViewController {

    // MARK: - UI

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerCard,
            descCard,
            buttonsStack
            
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let spacer = UIView()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            spacer,
            favouriteButton,
            linkButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            bookImageView,
            detailsStack
        ])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var detailsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            authorStack,
            categoriesStack,
            pagesStack,
            publishedStack
        ])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var descStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            descriptionTitleLabel,
            descriptionLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            wantToReadButton
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let authorLabel = UILabel()
    private let authorNameLabel = UILabel()
    
    private let categoriesLabel = UILabel()
    private let categoriesName = UILabel()
    
    private let pagesLabel = UILabel()
    private let pagesNum = UILabel()
    
    private let publishedLabel = UILabel()
    private let publishedYear = UILabel()
    
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let bookImageView = UIImageView()
    
    private let headerCard = CardView()
    private let descCard = CardView()
    
    
    let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
    private lazy var linkButton = makeIconButton(systemName: "link")
    private lazy var favouriteButton = makeIconButton(systemName: "heart", systemNameForSelected: "heart.fill")
    
    private func makeIconButton(systemName: String, systemNameForSelected: String? = nil) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: systemName, withConfiguration: config), for: .normal)
        if let imageName = systemNameForSelected {
            button.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .selected)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    private func makeHorizontalStack(firstLabel: UILabel, secondLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [
            firstLabel,
            secondLabel
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = 8
        
        firstLabel.font = .systemFont(ofSize: 16, weight: .medium)
        firstLabel.textColor = .label
        firstLabel.setContentHuggingPriority(.required, for: .horizontal)
        firstLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        secondLabel.font = .systemFont(ofSize: 16)
        secondLabel.textColor = .label
        secondLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        secondLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        secondLabel.numberOfLines = 0
        return stack
    }
    
    private lazy var authorStack = makeHorizontalStack(firstLabel: authorLabel, secondLabel: authorNameLabel)
    private lazy var categoriesStack = makeHorizontalStack(firstLabel: categoriesLabel, secondLabel: categoriesName)
    private lazy var pagesStack = makeHorizontalStack(firstLabel: pagesLabel, secondLabel: pagesNum)
    private lazy var publishedStack = makeHorizontalStack(firstLabel: publishedLabel, secondLabel: publishedYear)
    
    private let wantToReadButton = UIButton()

    // MARK: - Init
    
    var detailsViewModel: BookDetailsViewModelProtocol

    init(viewModel: BookDetailsViewModelProtocol) {
        self.detailsViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = detailsViewModel.titleText
        
        setupHierarchy()
        setupLayout()
        setupAppearance()
        bindViewModel()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavouriteButton(detailsViewModel.isFavourite)
        updateWantToReadButton(detailsViewModel.isWantToRead)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        detailsViewModel.cleanupIfNeeded()
    }


    // MARK: - Setup

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        headerCard.addSubview(headerStack)
        headerCard.addSubview(separatorView)
        headerCard.addSubview(infoStack)
        descCard.addSubview(descStack)
        
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            headerStack.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),

            separatorView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            infoStack.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            infoStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            infoStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -16),

            bookImageView.widthAnchor.constraint(equalToConstant: 120),
            bookImageView.heightAnchor.constraint(equalToConstant: 160),

            descStack.topAnchor.constraint(equalTo: descCard.topAnchor, constant: 16),
            descStack.leadingAnchor.constraint(equalTo: descCard.leadingAnchor, constant: 16),
            descStack.trailingAnchor.constraint(equalTo: descCard.trailingAnchor, constant: -16),
            descStack.bottomAnchor.constraint(equalTo: descCard.bottomAnchor, constant: -16)
        ])
    }

    private func setupAppearance() {
        if let _ = detailsViewModel.buyLink {
            linkButton.isHidden = false
        } else {
            linkButton.isHidden = true
        }
    
        descriptionTitleLabel.font = .boldSystemFont(ofSize: 18)

        descriptionLabel.numberOfLines = 0
        categoriesLabel.numberOfLines = 0
        authorLabel.numberOfLines = 0

        bookImageView.contentMode = .scaleAspectFit
        
        wantToReadButton.setTitle("Want to read", for: .normal)
        wantToReadButton.setTitleColor(.white, for: .normal)
        wantToReadButton.backgroundColor = .systemBlue
        wantToReadButton.layer.cornerRadius = 8
        
    }

    private func bindViewModel() {
        titleLabel.text = detailsViewModel.titleText
        bookImageView.loadImage(from: detailsViewModel.imageURL)
        authorLabel.text = String(localized: "authors")
        authorNameLabel.text = detailsViewModel.authorText
        categoriesLabel.text = String(localized: "categories")
        categoriesName.text = detailsViewModel.categories
        pagesLabel.text = String(localized: "pages")
        pagesNum.text = detailsViewModel.pageAmount
        publishedLabel.text = String(localized: "publishedDate")
        publishedYear.text = detailsViewModel.publishedYearText
        descriptionTitleLabel.text = String(localized: "description")
        descriptionLabel.text = detailsViewModel.descriptionText
    }
    

    private func setupActions() {
        linkButton.addTarget(self, action: #selector(openLinkTapped), for: .touchUpInside)
        
        favouriteButton.addTarget(self, action: #selector(favouriteTapped), for: .touchUpInside)
        wantToReadButton.addTarget(self, action: #selector(wantToReadTapped), for: .touchUpInside)

        detailsViewModel.onFavoriteChanged = { [weak self] isFav in
            self?.updateFavouriteButton(isFav)
        }
        
        detailsViewModel.onWantToReadChanged = { [weak self] isWant in
            self?.updateWantToReadButton(isWant)
        }
    }

    // MARK: - Actions

    @objc private func favouriteTapped() {
        detailsViewModel.toggleFav()
    }
    
    @objc private func wantToReadTapped() {
        detailsViewModel.toggleWantToRead()
    }

    @objc private func openLinkTapped() {
        guard let url = detailsViewModel.buyLink else { return }
        present(SFSafariViewController(url: url), animated: true)
    }

    private func updateFavouriteButton(_ isFav: Bool) {
        favouriteButton.isSelected = isFav
        favouriteButton.tintColor = isFav ? .systemPink : .systemGray
    }
    
    private func updateWantToReadButton(_ isWant: Bool) {
        wantToReadButton.isSelected = isWant
        wantToReadButton.backgroundColor = isWant ? .systemBlue : .systemGray
    }
}
