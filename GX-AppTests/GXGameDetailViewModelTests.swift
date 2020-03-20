//
//  GXGameDetailViewModelTests.swift
//  GX-AppTests
//
//  Created by M. Barış ÇİÇEK on 20.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import XCTest
@testable import GameX

final class GXGameDetailViewModelTests: XCTestCase {

    private var viewModel: GXGameDetailViewModelType!
    
    // Dependencies
    private var gamesRepository: GXGamesRepositoryType!
    private var favouritesRepository: GXFavouritesRepositoryType!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gamesRepository = GXGamesMockRepository(delay: 0)
        favouritesRepository = GXFavouritesMockRepository()
        
        let entity = GXGameEntity(id: 3498, name: "Grand Theft Auto V", backgroundImage: nil, genres: [], metacritic: nil)
        let presentation = GXGamePresentation(entity: entity)
        
        viewModel = GXGameDetailViewModel(dependency: .init(presentation: presentation,
                                                            gamesRepository: gamesRepository,
                                                            favouritesRepository: favouritesRepository))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        gamesRepository = nil
        favouritesRepository = nil
    }
    
    func testCheckIsInFavouriteFalse() {
        let isInFavouriteExpectation = expectation(description: "Is in favourite")
        isInFavouriteExpectation.expectedFulfillmentCount = 1
        
        var isFavouritedResult: Bool = false
        
        viewModel.outputs.isInFavouriteNotifier = { isFavourited in
            isFavouritedResult = isFavourited
            isInFavouriteExpectation.fulfill()
        }
        
        viewModel.inputs.viewDidLoaded()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(isFavouritedResult == false)
    }
    
    func testCheckIsInFavouriteTrue() {
        let isInFavouriteExpectation = expectation(description: "Is in favourite")
        isInFavouriteExpectation.expectedFulfillmentCount = 2
        
        var isFavouritedResult: Bool = false
        
        viewModel.outputs.isInFavouriteNotifier = { isFavourited in
            isFavouritedResult = isFavourited
            isInFavouriteExpectation.fulfill()
        }
        
        viewModel.inputs.viewDidLoaded()
        viewModel.inputs.addFavourite()
        
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(isFavouritedResult == true)
    }

}
