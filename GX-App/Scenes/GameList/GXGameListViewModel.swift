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
    func fetchGameList()
    func fetchFavouriteList()
    func setSearchActive(isActive: Bool)
    func setSearchQuery(query: String?)
    func removeFavourite(index: Int)
}

protocol GXGameListViewModelOutputs {
    var reloadNotifier: () -> Void { get set }
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void { get set }
    var numberOfItems: Int { get }
    func itemForIndex(_ index: Int) -> GXGamePresentation?
    func selectedItemForIndex(_ index: Int) -> GXGamePresentation
}

protocol GXGameListViewModelType {
    var inputs: GXGameListViewModelInputs { get }
    var outputs: GXGameListViewModelOutputs { get set }
}

final class GXGameListViewModel: GXGameListViewModelType, GXGameListViewModelInputs, GXGameListViewModelOutputs {
    
    struct Dependency {
        let gamesRepository: GXGamesRepositoryType
        let favouritesRepository: GXFavouritesRepositoryType
    }
    
    // MARK: INITIALIZERS
    
    private let viewState: GXGameListViewState
    private let dependency: Dependency
    
    init(viewState: GXGameListViewState, dependency: Dependency) {
        self.viewState = viewState
        self.dependency = dependency
    }
    
    // MARK: VIEWMODEL TYPE
    
    var inputs: GXGameListViewModelInputs { return self }
    var outputs: GXGameListViewModelOutputs {
        get { return self } set {}
    }
    
    // MARK: PROPERTIES
    
    private var isLoading: Bool = false
    
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
    
    private var _favouritePresentationsResults: [GXGamePresentation] = [] {
        didSet {
            reloadNotifier()
        }
    }
    
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
            switch viewState {
            case .gameList:
                return isSearchActive ? _searchedPresentationsResults : _gamePresentationsResults
            case .favourites:
                return _favouritePresentationsResults
            }
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
        
        switch viewState {
        case .gameList:
            fetchGameList()
        case .favourites:
            fetchFavouriteList()
        }
    }
    
    func viewWillAppeared() {
        switch viewState {
        case .gameList:
            // This reload necessary for item viewed updates
            reloadNotifier()
        case .favourites:
            fetchFavouriteList()
        }
    }
    
    func fetchGameList() {
        guard isLoading == false else { return }
        
        if isSearchActive {
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
                
                if strongSelf.isSearchActive {
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
    
    func fetchFavouriteList() {
        dependency.favouritesRepository.fetchFavouriteList { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let entity):
                guard let entity = entity else { return }
                let presentations: [GXGamePresentation] = entity.games.map(GXGamePresentation.init(entity:))
                strongSelf._favouritePresentationsResults = presentations
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setSearchActive(isActive: Bool) {
        isSearchActive = isActive
    }
    
    func setSearchQuery(query: String?) {
        searchQuery = query
    }
    
    func removeFavourite(index: Int) {
        let removableItem = _favouritePresentationsResults[index]
        dependency.favouritesRepository.removeFavourite(game: removableItem.entity) { [weak self] in
            self?._favouritePresentationsResults.remove(at: index)
        }
    }
    
    // MARK: OUTPUTS
    
    var reloadNotifier: () -> Void = {}
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void = {_ in}
    
    var numberOfItems: Int {
        return displayedPresentations.count
    }
    
    func itemForIndex(_ index: Int) -> GXGamePresentation? {
        guard index < displayedPresentations.count else {
            return nil
        }
        return displayedPresentations[index]
    }
    
    /**
     - selectedItemForIndex and itemForIndex exactly same function,
     - separated because maybe we will integrate analytics tool.
     */
    func selectedItemForIndex(_ index: Int) -> GXGamePresentation {
        return displayedPresentations[index]
    }
    
}
