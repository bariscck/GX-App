//
//  GXGameDetailViewController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

enum GXGameDetailTableLayoutItems: Int, CaseIterable {
    case description    = 0
    case visitReddit    = 1
    case visitWebsite   = 2
}

final class GXGameDetailViewController: UIViewController, GXAlertPresenter {

    // MARK: INITIALIZERS
    
    private var viewModel: GXGameDetailViewModelType
    private let router: GXGameDetailRouterType
    
    init(viewModel: GXGameDetailViewModelType, router: GXGameDetailRouterType) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(String(describing: self) + " is deallocated!")
    }
    
    // MARK: VIEWS
    
    private lazy var gameHeaderView: GXGameHeaderView = {
        return GXGameHeaderView.fromNib()
    }()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Configs
            tableView.backgroundColor = GXTheme.backgroundColor
            tableView.rowHeight = UITableView.automaticDimension
            tableView.showsVerticalScrollIndicator = false
            tableView.tableFooterView = UIView()
            // Setting Datasource
            tableView.dataSource = self
            tableView.delegate = self
            // Register Cells
            tableView.register(xibClass: GXExpandableDescriptionCell.self)
            tableView.register(xibClass: TitledCell.self)
        }
    }
    
    private lazy var favouriteBtn: UIBarButtonItem = {
        return UIBarButtonItem(title: "Favourite", style: .plain, target: self,
                               action: #selector(favourite(_:)))
    }()
    
    // MARK: MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupGameHeaderView()
        // ViewModel methods
        setupVMBindings()
        viewModel.inputs.viewDidLoaded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 290)
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = favouriteBtn
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupGameHeaderView() {
        tableView.tableHeaderView = gameHeaderView
        gameHeaderView.setup(with: viewModel.outputs.currentPresentation)
    }
    
    private func setupVMBindings() {
        viewModel.outputs.presentationFetchedNotifier = { [unowned self] presentation in
            self.gameHeaderView.setup(with: presentation)
            self.tableView.reloadData()
        }
        
        viewModel.outputs.didReceiveServiceErrorNotifier = { serviceError in
            print(serviceError)
        }
    }
    
    // MARK: ACTIONS
    
    @objc private func favourite(_ sender: UIBarButtonItem) {
        GXFeedbackGenerator.generate()
        print("Favourite")
        presentInfoAlert(title: "\(viewModel.outputs.currentPresentation.title) is added your favourite list.")
    }

}

extension GXGameDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let layoutItem = viewModel.outputs.layoutItem(for: indexPath.row)
        
        switch layoutItem {
        case .description:
            let descriptionCell = tableView.dequeue(cellClass: GXExpandableDescriptionCell.self, forIndexPath: indexPath)
            
            descriptionCell.setup(with: viewModel.outputs.currentPresentation) {
                tableView.performBatchUpdates(nil)
            }
            
            return descriptionCell
        case .visitReddit, .visitWebsite:
            let titledCell = tableView.dequeue(cellClass: TitledCell.self, forIndexPath: indexPath)
            
            switch layoutItem {
            case .visitReddit:
                titledCell.setup(with: "Visit reddit")
            case .visitWebsite:
                titledCell.setup(with: "Visit website")
            default:
                break
            }
            
            return titledCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedLayoutItem = viewModel.outputs.layoutItem(for: indexPath.row)
       
        switch selectedLayoutItem {
        case .visitReddit, .visitWebsite:
            print("Open Safari")
        default:
            break
        }
    }
    
}
