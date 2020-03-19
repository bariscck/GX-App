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
    
    // MARK: INITIALIZERS
    
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
    
    private var isLoading: Bool = false
    
    private var currentlyDisplayingIndex: Int = 0 {
        didSet {
            if currentlyDisplayingIndex == displayedPresentations.count - 1 {
                fetchGameList(isSearch: isSearchActive)
            }
        }
    }
    
    /// Search Properties
    
    private var isSearchActive: Bool = false {
        didSet {
            reloadNotifier()
        }
    }
    
    private var searchQuery: String? {
        didSet {
            if searchQuery != oldValue {
                _searchedPresentationsResults = []
                _searchedNextURL = nil
            }
        }
    }
    
    /// Presentation Properties
    
    private var _gamesNextURL: URL?
    private var _gamePresentationsResults: [GXGamePresentation] = [] {
        didSet {
            _gamePresentationsResults = _gamePresentationsResults.unique()
            reloadNotifier()
        }
    }
    
    private var _searchedNextURL: URL?
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
    private var nextURL: URL? {
        get {
            isSearchActive ? _searchedNextURL : _gamesNextURL
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
            // Trim query characters for whitespaces
            let trimmedQuery = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            // Check query count is valid. Count must be at least 4
            guard trimmedQuery.count >= 4 else {
                return
            }
        }
        
        isLoading = true
        
        dependency.gamesRepository.fetchGameList(query: searchQuery, nextURL: nextURL) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let entity):
                strongSelf.isLoading = false
                guard let presentations: [GXGamePresentation] = entity?.games.compactMap(GXGamePresentation.init(entity:)) else {
                    return // TODO: SHOW NO RESULTS FOUND
                }
                
                if isSearch {
                    strongSelf._searchedPresentationsResults.append(contentsOf: presentations)
                    strongSelf._searchedNextURL = entity?.nextURL
                } else {
                    strongSelf._gamePresentationsResults.append(contentsOf: presentations)
                    strongSelf._gamesNextURL = entity?.nextURL
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
        searchQuery = query
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
