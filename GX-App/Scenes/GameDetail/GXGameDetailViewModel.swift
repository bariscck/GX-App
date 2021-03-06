//
//  GXGameDetailViewModel.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXGameDetailViewModelInputs {
    func viewDidLoaded()
    func fetchGameDetail()
    func addFavourite()
    func removeFavourite()
}

protocol GXGameDetailViewModelOutputs {
    var currentPresentation: GXGamePresentation { get set }
    var reloadNotifier: () -> Void { get set }
    var isInFavouriteNotifier: (Bool) -> Void { get set }
    var presentationFetchedNotifier: (GXGamePresentation) -> Void { get set }
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void { get set }
    func numberOfItems() -> Int
    func layoutItem(for index: Int) -> GXGameDetailTableLayoutItems
}

protocol GXGameDetailViewModelType {
    var inputs: GXGameDetailViewModelInputs { get }
    var outputs: GXGameDetailViewModelOutputs { get set }
}

final class GXGameDetailViewModel: GXGameDetailViewModelType, GXGameDetailViewModelInputs, GXGameDetailViewModelOutputs {
    
    struct Dependency {
        let presentation: GXGamePresentation
        let gamesRepository: GXGamesRepositoryType
        let favouritesRepository: GXFavouritesRepositoryType
    }
    
    // MARK: INITIALIZERS
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        currentPresentation = dependency.presentation
    }
    
    deinit {
        print(String(describing: self) + " is deallocated!")
    }
    
    // MARK: PROPERTIES
    
    private var isLoading: Bool = false {
        didSet {
            reloadNotifier()
        }
    }
    
    // MARK: VIEWMODEL TYPE
    
    var inputs: GXGameDetailViewModelInputs { return self }
    var outputs: GXGameDetailViewModelOutputs {
        get { return self } set {}
    }
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        checkIsInFavourite()
        fetchGameDetail()
    }
    
    func fetchGameDetail() {
        isLoading = true
        dependency.gamesRepository.fetchGameDetail(gameId: dependency.presentation.id) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let entity):
                guard let entity = entity else { return }
                let presentation = strongSelf.currentPresentation
                presentation.update(with: entity)
                strongSelf.isLoading = false
                strongSelf.currentPresentation = presentation
                // Add item id to viewed games
                GXViewedGamesStorage.addViewedGame(id: presentation.id)
            case .failure(let error):
                strongSelf.isLoading = false
                strongSelf.didReceiveServiceErrorNotifier(error)
            }
        }
    }
    
    func addFavourite() {
        dependency.favouritesRepository.addFavourite(game: currentPresentation.entity) { [weak self] in
            self?.isInFavouriteNotifier(true)
        }
    }
    
    func removeFavourite() {
        dependency.favouritesRepository.removeFavourite(game: currentPresentation.entity) { [weak self] in
            self?.isInFavouriteNotifier(false)
        }
    }
    
    // MARK: OUTPUTS
    
    var currentPresentation: GXGamePresentation {
        didSet {
            presentationFetchedNotifier(currentPresentation)
            reloadNotifier()
        }
    }
    
    var reloadNotifier: () -> Void = {}
    var isInFavouriteNotifier: (Bool) -> Void = {_ in}
    var presentationFetchedNotifier: (GXGamePresentation) -> Void = {_ in}
    var didReceiveServiceErrorNotifier: (GXGameServiceError) -> Void = {_ in}
    
    func numberOfItems() -> Int {
        return isLoading ? 0 : GXGameDetailTableLayoutItems.allCases.count
    }
    
    func layoutItem(for index: Int) -> GXGameDetailTableLayoutItems {
        guard let item = GXGameDetailTableLayoutItems.init(rawValue: index) else {
            fatalError("Error: \(GXGameDetailTableLayoutItems.self) does not contain index: \(index)")
        }
        return item
    }
    
    // MARK: HELPERS
    
    private func checkIsInFavourite() {
        dependency.favouritesRepository.checkIsFavourited(id: currentPresentation.id) { [weak self] (isFavourited) in
            self?.isInFavouriteNotifier(isFavourited)
        }
    }
    
}
