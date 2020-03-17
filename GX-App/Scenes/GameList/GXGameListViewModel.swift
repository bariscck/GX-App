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
    func fetchGameList(with pagination: Bool)
}

protocol GXGameListViewModelOutputs {
    var reloadNotifier: () -> Void { get set }
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void { get set }
    func numberOfItems() -> Int
    func itemForIndex(_ index: Int) -> GXGamePresentation
    func selectedItemForIndex(_ index: Int) -> GXGamePresentation
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

    private var nextPageURL: URL?
    
    private var gameListPresentations: [GXGamePresentation] = [] {
        didSet {
            reloadNotifier()
        }
    }
    
    private var viewedGamePresentationIds: [Int] = []
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        fetchGameList()
    }
    
    func fetchGameList(with pagination: Bool = true) {
        let nextURL = pagination ? self.nextPageURL : nil
        dependency.gameService.fetchGameList(query: nil, nextURL: nextURL) { [weak self] (result) in
            switch result {
            case .success(let response):
                let presentations = response.results.map(GXGamePresentation.init(game:))
                self?.gameListPresentations.append(contentsOf: presentations)
                self?.nextPageURL = response.next
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
    
    func selectedItemForIndex(_ index: Int) -> GXGamePresentation {
        var item = gameListPresentations[index]
        viewedGamePresentationIds.append(item.id)
        item.setViewed()
        gameListPresentations[index] = item
        return item
    }
    
}
