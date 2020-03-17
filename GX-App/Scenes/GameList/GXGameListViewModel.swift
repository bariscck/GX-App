//
//  GXGameListViewModel.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXGameListViewModelInputs {
    func viewDidLoaded()
}

protocol GXGameListViewModelOutputs {
    func numberOfItems() -> Int
    func itemForIndex(_ index: Int) -> GXGamePresentation
}

protocol GXGameListViewModelType {
    var inputs: GXGameListViewModelInputs { get }
    var outputs: GXGameListViewModelOutputs { get set }
}

final class GXGameListViewModel: GXGameListViewModelType, GXGameListViewModelInputs, GXGameListViewModelOutputs {
    
    struct Dependency {
        let gameService: GXGameServiceType
    }
    
    // INITIALIZERS
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: VIEWMODEL TYPE
    
    var inputs: GXGameListViewModelInputs { return self }
    var outputs: GXGameListViewModelOutputs {
        get { return self } set {}
    }
    
    // MARK: PROPERTIES
    
    private var gameListPresentations: [GXGamePresentation] = []
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        dependency.gameService.fetchGameList(query: nil, nextURL: nil) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: OUTPUTS
    
    func numberOfItems() -> Int {
        return gameListPresentations.count
    }
    
    func itemForIndex(_ index: Int) -> GXGamePresentation {
        return gameListPresentations[index]
    }
    
}
