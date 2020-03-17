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
    func setSearchActive(isActive: Bool)
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

    private var viewedGamePresentationIds: Set<Int> = []
    private var isSearchActive: Bool = false {
        didSet {
            if oldValue != isSearchActive {
                if isSearchActive { } else {
                    _searchedPresentations.removeAll()
                }
                _searchedNextPageURL = nil
            }
            
            reloadNotifier()
        }
    }
    
    private var _gamePresentations: [GXGamePresentation] = []
    private var _gamesNextPageURL: URL?
    private var _searchedPresentations: [GXGamePresentation] = []
    private var _searchedNextPageURL: URL?
    
    private var displayedPresentations: [GXGamePresentation] {
        get {
            return isSearchActive ? _searchedPresentations : _gamePresentations
        }
    }
    
    private var nextPageURL: URL? {
        get {
            return isSearchActive ? _searchedNextPageURL : _gamesNextPageURL
        }
    }
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        setSearchActive(isActive: false)
        fetchGameList()
    }
    
    func fetchGameList() {
        dependency.gameService.fetchGameList(query: nil, nextURL: nextPageURL) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                let presentations = response.results.map(GXGamePresentation.init(game:))
                
                if strongSelf.isSearchActive {
                    strongSelf._searchedPresentations.append(contentsOf: presentations)
                    strongSelf._searchedNextPageURL = response.next
                } else {
                    strongSelf._gamePresentations.append(contentsOf: presentations)
                    strongSelf._gamesNextPageURL = response.next
                }
                
                strongSelf.reloadNotifier()
            case .failure(let error):
                self?.didReceiveServiceErrorNotifier(error)
            }
        }
    }
    
    func setSearchActive(isActive: Bool) {
        self.isSearchActive = isActive
    }
    
    // MARK: OUTPUTS
    
    var reloadNotifier: () -> Void = {}
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void = {_ in}
    
    func numberOfItems() -> Int {
        return displayedPresentations.count
    }
    
    func itemForIndex(_ index: Int) -> GXGamePresentation {
        return displayedPresentations[index]
    }
    
    func selectedItemForIndex(_ index: Int) -> GXGamePresentation {
        var item = displayedPresentations[index]
        viewedGamePresentationIds.update(with: item.id)
        item.setViewed()
        return item
    }
    
}
