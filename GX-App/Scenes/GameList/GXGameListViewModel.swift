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
    func fetchGameList()
}

protocol GXGameListViewModelOutputs {
    var reloadNotifier: () -> Void { get set }
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void { get set }
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
    
    private var gameListPresentations: [GXGamePresentation] = [] {
        didSet {
            reloadNotifier()
        }
    }
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        fetchGameList()
    }
    
    func fetchGameList() {
        dependency.gameService.fetchGameList(query: nil, nextURL: nil) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.gameListPresentations = response.results.map(GXGamePresentation.init(game:))
            case .failure(let error):
                self?.didReceiveServiceErrorNotifier(error)
            }
        }
    }
    
    // MARK: OUTPUTS
    
    var reloadNotifier: () -> Void = {}
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void = {_ in}
    
    func numberOfItems() -> Int {
        return gameListPresentations.count
    }
    
    func itemForIndex(_ index: Int) -> GXGamePresentation {
        return gameListPresentations[index]
    }
    
}
