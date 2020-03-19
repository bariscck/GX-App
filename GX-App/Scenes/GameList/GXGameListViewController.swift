//
//  GXGameListViewController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class GXGameListViewController: UIViewController {

    // MARK: INITIALIZERS

    private var viewModel: GXGameListViewModelType
    private let router: GXGameListRouterType
    
    init(viewModel: GXGameListViewModelType, router: GXGameListRouterType) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: VIEWS
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = GXTheme.tableGroupedBackgroundColor
            // Setting Datasource
            collectionView.dataSource = self
            collectionView.delegate = self
            // Register Cells
            collectionView.register(xibClass: GXGameListCell.self)
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
        setupNavigationItem()
        // ViewModel methods
        setupVMBindings()
        viewModel.inputs.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppeared()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Games"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupVMBindings() {
        viewModel.outputs.reloadNotifier = {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.outputs.didReceiveServiceErrorNotifier = { serviceError in
            print(serviceError)
        }
    }

}

extension GXGameListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellClass: GXGameListCell.self, forIndexPath: indexPath)
        
        let presentation = viewModel.outputs.itemForIndex(indexPath.row)
        cell.setup(with: presentation)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GXFeedbackGenerator.generate()
        
        let selectedPresentation = viewModel.outputs.selectedItemForIndex(indexPath.row)
        router.pushGameDetailVC(for: selectedPresentation)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.inputs.setDisplayingIndex(index: indexPath.item)
    }
    
}

extension GXGameListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIApplication.shared.statusBarOrientation
        let width = collectionView.bounds.width
        
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return CGSize(width: width, height: 136)
        case .landscapeLeft, .landscapeRight:
            return CGSize(width: width / 2, height: 136)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
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
