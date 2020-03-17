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
    
    // MARK: MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVMBindings()
        viewModel.inputs.viewDidLoaded()
    }
    
    private func setupVMBindings() {
        
    }

}
