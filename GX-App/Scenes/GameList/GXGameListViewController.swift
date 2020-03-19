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
        switch state {
        case .gameList:
            navigationItem.title = "Games"
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        case .favourites:
            navigationItem.title = "Favourites"
        }
        
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupVMBindings() {
        viewModel.outputs.reloadNotifier = {
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
        let alertController = UIAlertController(title: "Are you sure?",
                                                message: "\(presentation.title) is removing your favourites",
                                                preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (act) in
            self?.viewModel.inputs.removeFavourite(index: index)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

}

extension GXGameListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: GXGameListCell.self, forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        let presentation = viewModel.outputs.itemForIndex(indexPath.row)
        cell.setup(with: presentation, updateBackgroundColor: viewState == .gameList)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewState == .gameList {
            // Update viewmodel's displaying index for pagination
            viewModel.inputs.setDisplayingIndex(index: indexPath.item)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Generate feedback when item selected
        GXFeedbackGenerator.generate()
        
        let selectedPresentation = viewModel.outputs.selectedItemForIndex(indexPath.row)
        router.pushGameDetailVC(for: selectedPresentation)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presentRemoveFavouriteAlert(for: viewModel.outputs.itemForIndex(indexPath.row), index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewState == .favourites {
            return .delete
        }
        
        return .none
    }
    
}

extension GXGameListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.inputs.setSearchQuery(query: query)
    }
    
}

extension GXGameListViewController: UISearchBarDelegate {
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.fetchGameList(isSearch: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.inputs.setSearchActive(isActive: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.setSearchActive(isActive: false)
    }
    
}
