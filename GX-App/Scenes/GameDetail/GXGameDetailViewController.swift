//
//  GXGameDetailViewController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class GXGameDetailViewController: UIViewController {

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
    
    // MARK: MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
