//
//  GXGameDetailViewController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

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
    
    // MARK: VIEWS
    
    private lazy var gameHeaderView: GXGameHeaderView = {
        return GXGameHeaderView.fromNib()
    }()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Configs
            tableView.backgroundColor = GXTheme.backgroundColor
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
            // Setting Datasource
            tableView.dataSource = self
            tableView.delegate = self
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
        gameHeaderView.setupForDevelopment()
    }
    
    // MARK: ACTIONS
    
    @objc private func favourite(_ sender: UIBarButtonItem) {
        GXFeedbackGenerator.generate()
        print("Favourite")
        presentInfoAlert(title: "GAME_NAME is added your favourite list.")
    }

}

extension GXGameDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
