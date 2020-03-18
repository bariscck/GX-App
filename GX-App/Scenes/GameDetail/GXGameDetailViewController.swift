//
//  GXGameDetailViewController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

enum GXGameDetailTableLayoutItems: Int, CaseIterable {
    case description = 0, reddit, website
}

final class GXGameDetailViewController: UIViewController, GXAlertPresenter {

    // MARK: INITIALIZERS
    
    private var viewModel: GXGameDetailViewModelType
    private let router: GXGameDetailRouterType
    
    init(viewModel: GXGameDetailViewModelType, router: GXGameDetailRouterType) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(String(describing: self) + " is deallocated!")
    }
    
    // MARK: PROPERTIES
    
    private let headerHeight: CGFloat = 290
    
    // MARK: VIEWS
    
    private lazy var gameHeaderView: GXGameHeaderView = {
        return GXGameHeaderView.fromNib()
    }()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Configs
            tableView.backgroundColor = GXTheme.backgroundColor
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 120
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
        updateHeaderViewFrame()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = favouriteBtn
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupGameHeaderView() {
        gameHeaderView.setup(with: viewModel.outputs.currentPresentation)
        tableView.addSubview(gameHeaderView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
    }
    
    private func updateHeaderViewFrame() {
        var headerFrame = CGRect(x: 0, y: -headerHeight, width: view.bounds.width, height: headerHeight)
        
        if tableView.contentOffset.y < headerHeight {
            headerFrame.origin.y = tableView.contentOffset.y
            headerFrame.size.height = -tableView.contentOffset.y
        }
        
        gameHeaderView.frame = headerFrame
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
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            return descriptionCell
        case .reddit, .website:
            let titledCell = tableView.dequeue(cellClass: TitledCell.self, forIndexPath: indexPath)
            
            switch layoutItem {
            case .reddit:
                titledCell.setup(with: "Visit reddit")
            case .website:
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
        let currentPresentation = viewModel.outputs.currentPresentation
        var url: URL?
        
        switch selectedLayoutItem {
        case .reddit   : url = currentPresentation.redditLink?.url
        case .website  : url = currentPresentation.websiteLink?.url
        default:
            return
        }
        
        if let url = url {
            router.openSFSafariController(for: url)
        }
    }
    
}

extension GXGameDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderViewFrame()
    }
    
}
