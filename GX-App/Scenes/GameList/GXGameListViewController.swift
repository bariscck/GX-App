//
//  GXGameListViewController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

enum GXGameListViewState {
    case gameList, favourites
}

final class GXGameListViewController: UIViewController, GXAlertPresenter {

    // MARK: INITIALIZERS

    private let viewState: GXGameListViewState
    private var viewModel: GXGameListViewModelType
    private let router: GXGameListRouterType
    
    init(viewState: GXGameListViewState, viewModel: GXGameListViewModelType, router: GXGameListRouterType) {
        self.viewState = viewState
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: PROPERTIES
    
    private let paginationDistance: CGFloat = 200
    
    private var navigationTitle: String {
        get {
            switch viewState {
            case .gameList:
                return "Games"
            case .favourites:
                return "Favourites"
            }
        }
    }
    
    // MARK: VIEWS
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = GXTheme.tableGroupedBackgroundColor
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 136
            // Setting Datasource
            tableView.dataSource = self
            tableView.delegate = self
            // Register Cells
            tableView.register(xibClass: GXGameListCell.self)
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for the games"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // MARK: MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem(for: viewState)
        // ViewModel methods
        setupVMBindings()
        viewModel.inputs.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppeared()
    }
    
    private func setupNavigationItem(for state: GXGameListViewState) {
        navigationItem.title = navigationTitle
        navigationItem.largeTitleDisplayMode = .automatic
        
        if state == .gameList {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func setupVMBindings() {
        viewModel.outputs.reloadNotifier = { [unowned self] in
            if self.viewState == .favourites {
                let numberOfItems = self.viewModel.outputs.numberOfItems
                
                if numberOfItems == 0 {
                    self.navigationItem.title = self.navigationTitle
                    self.tableView.emptyMessage(message: "There is no favourites found.")
                } else {
                    self.navigationItem.title = self.navigationTitle + " (\(numberOfItems))"
                    self.tableView.restore()
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        viewModel.outputs.didReceiveServiceErrorNotifier = { [weak self] serviceError in
            guard case let .serverError(error) = serviceError else { return }
            self?.presentInfoAlert(title: error.localizedDescription)
        }
    }
    
    private func presentRemoveFavouriteAlert(for presentation: GXGamePresentation, index: Int) {
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (act) in
            self?.viewModel.inputs.removeFavourite(index: index)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        presentAlert(title: "Are you sure", message: "\(presentation.title) is removing your favourites",
                     actions: [removeAction, cancelAction])
        
    }

}

extension GXGameListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: GXGameListCell.self, forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        if let presentation = viewModel.outputs.itemForIndex(indexPath.row) {
            cell.setup(with: presentation, updateBackgroundColor: viewState == .gameList)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Generate feedback when item selected
        GXFeedbackGenerator.generate()
        
        let selectedPresentation = viewModel.outputs.selectedItemForIndex(indexPath.row)
        router.pushGameDetailVC(for: selectedPresentation)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete, let presentation = viewModel.outputs.itemForIndex(indexPath.item) else {
            return
        }
        presentRemoveFavouriteAlert(for: presentation, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewState == .favourites {
            return .delete
        }
        
        return .none
    }
    
}

extension GXGameListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard viewState == .gameList else { return }
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if distance < paginationDistance {
            viewModel.inputs.fetchGameList()
        }
    }
}

extension GXGameListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.inputs.setSearchQuery(query: query)
        
        if viewModel.outputs.numberOfItems == 0, (query.count >= 0 && query.count < 3) {
            tableView.emptyMessage(message: "No game has been searched.")
        } else {
            tableView.restore()
        }
    }
    
}

extension GXGameListViewController: UISearchBarDelegate {
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.fetchGameList()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.inputs.setSearchActive(isActive: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.setSearchActive(isActive: false)
    }
    
}
