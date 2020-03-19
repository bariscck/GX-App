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
    func viewWillAppeared()
    func fetchGameList(isSearch: Bool)
    func setDisplayingIndex(index: Int)
    func setSearchActive(isActive: Bool)
    func setSearchQuery(query: String?)
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
        let gamesRepository: GXGamesRepositoryType
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

    private var currentlyDisplayingIndex: Int = 0 {
        didSet {
            if currentlyDisplayingIndex == displayedPresentations.count - 1 {
                fetchGameList(isSearch: isSearchActive)
            }
        }
    }
    
    private var viewedGamePresentationIds: Set<Int> = []
    
    private var isSearchActive: Bool = false {
        didSet {
            reloadNotifier()
        }
    }
    
    private var isLoading: Bool = false
    
    private var searchQuery: String? {
        didSet {
            if searchQuery != oldValue {
                _searchedPresentationsResults = []
            }
        }
    }
    
    private var _gamePresentationsResults: [GXGamePresentation] = [] {
        didSet {
            _gamePresentationsResults = _gamePresentationsResults.unique()
            reloadNotifier()
        }
    }
    private var _searchedPresentationsResults: [GXGamePresentation] = [] {
        didSet {
            _searchedPresentationsResults = _searchedPresentationsResults.unique()
            reloadNotifier()
        }
    }
    
    private var displayedPresentations: [GXGamePresentation] {
        get {
            isSearchActive ? _searchedPresentationsResults : _gamePresentationsResults
        }
    }
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        setSearchActive(isActive: false)
        fetchGameList(isSearch: false)
    }
    
    func viewWillAppeared() {
        reloadNotifier()
    }
    
    func fetchGameList(isSearch: Bool) {
        guard isLoading == false else { return }
        
        if isSearch {
            guard (searchQuery ?? "").count > 3 else {
                return
            }
        }
        
        isLoading = true
        
        dependency.gamesRepository.fetchGameList(query: searchQuery) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let entity):
                strongSelf.isLoading = false
                guard let presentations: [GXGamePresentation] = entity?.games.compactMap(GXGamePresentation.init(entity:)) else {
                    return // TODO: SHOW NO RESULTS
                }
                
                if isSearch {
                    strongSelf._searchedPresentationsResults.append(contentsOf: presentations)
                } else {
                    strongSelf._gamePresentationsResults.append(contentsOf: presentations)
                }
            case .failure(let error):
                strongSelf.isLoading = false
                strongSelf.didReceiveServiceErrorNotifier(error)
            }
        }
    }
    
    func setDisplayingIndex(index: Int) {
        currentlyDisplayingIndex = index
    }
    
    func setSearchActive(isActive: Bool) {
        isSearchActive = isActive
    }
    
    func setSearchQuery(query: String?) {
        searchQuery = query?.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    // selectedItemForIndex and itemForIndex exactly same function
    // selectedItemForIndex separated because maybe we will integrate analytics tool.
    func selectedItemForIndex(_ index: Int) -> GXGamePresentation {
        return displayedPresentations[index]
    }
    
}
