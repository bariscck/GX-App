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
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Configs
            tableView.backgroundColor = GXTheme.tableGroupedBackgroundColor
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 136
            tableView.separatorStyle = .none
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
    
    private func setupNavigationItem() {
        navigationItem.title = "Games"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupVMBindings() {
        viewModel.outputs.reloadNotifier = { [unowned self] in
            self.tableView.reloadData()
        }
        
        viewModel.outputs.didReceiveServiceErrorNotifier = { serviceError in
            print(serviceError)
        }
    }

}

extension GXGameListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: GXGameListCell.self, forIndexPath: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let presentation = viewModel.outputs.itemForIndex(indexPath.row)
        cell.setup(with: presentation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        GXFeedbackGenerator.generate()
        
        let selectedPresentation = viewModel.outputs.itemForIndex(indexPath.row)
        router.pushGameDetailVC(for: selectedPresentation)
    }
    
}
