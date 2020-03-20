//
//  GXGamesRepositoryTests.swift
//  GX-AppTests
//
//  Created by M. Barış ÇİÇEK on 20.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import XCTest
@testable import GameX

final class GXGameListViewModelTests: XCTestCase {
    
    private var viewModel: GXGameListViewModelType!
    
    // Dependencies
    private var gamesRepository: GXGamesRepositoryType!
    private var favouritesRepository: GXFavouritesRepositoryType!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gamesRepository = GXGamesMockRepository(delay: 0)
        favouritesRepository = GXFavouritesMockRepository()
        viewModel = GXGameListViewModel(viewState: .gameList, dependency: .init(gamesRepository: gamesRepository,
                                                                                favouritesRepository: favouritesRepository))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        gamesRepository = nil
        favouritesRepository = nil
    }
    
    func testFetchGameListWithoutSearchQuery() {
        // GIVEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // WHEN
        viewModel.inputs.fetchGameList()
        XCTAssertTrue(viewModel.outputs.numberOfItems != 0)
        
        // THEN
        let item = viewModel.outputs.itemForIndex(0)
        XCTAssertNotNil(item)
        XCTAssertTrue(item?.id == 3498)
        XCTAssertTrue(item?.title == "Grand Theft Auto V")
    }
    
    func testFetchGameListWithSearchQuery() {
        // GIVEN
        viewModel.inputs.setSearchActive(isActive: true)
        viewModel.inputs.setSearchQuery(query: "portal")
        
        // WHEN
        viewModel.inputs.fetchGameList()
        
        // THEN
        let item = viewModel.outputs.itemForIndex(0)
        XCTAssertNotNil(item)
        XCTAssertTrue(item?.id == 4200)
        XCTAssertTrue(item?.title == "Portal 2")
        
    }
    
    func testFetchGameListWithSearchingScenario() throws {
        // GIVEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // WHEN
        viewModel.inputs.fetchGameList()
        
        // THEN
        XCTAssertTrue(viewModel.outputs.numberOfItems > 0)
        let fetchedItem = viewModel.outputs.itemForIndex(0)
        XCTAssertNotNil(fetchedItem)
        
        // WHEN
        viewModel.inputs.setSearchActive(isActive: true)
        
        // THEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // GIVEN
        viewModel.inputs.setSearchQuery(query: "portal")
        
        // WHEN
        viewModel.inputs.fetchGameList()
        
        // THEN
        XCTAssertTrue(viewModel.outputs.numberOfItems > 0)
        let searchedItem = viewModel.outputs.itemForIndex(0)
        XCTAssertNotNil(searchedItem)
        
        // GIVEN
        viewModel.inputs.setSearchQuery(query: "askjafakjsfk :))")
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // WHEN
        viewModel.inputs.fetchGameList()
        
        // THEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // WHEN
        viewModel.inputs.setSearchActive(isActive: false)
        
        // THEN --> This must be 10 because we fetched before game list without searching
        XCTAssertTrue(viewModel.outputs.numberOfItems == 10)
        
    }
    
    func testFetchFavourites() throws {
        viewModel = GXGameListViewModel(viewState: .favourites, dependency: .init(gamesRepository: gamesRepository,
                                                                                  favouritesRepository: favouritesRepository))
        
        // GIVEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // WHEN
        viewModel.inputs.fetchFavouriteList()
        
        // THEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 0)
        
        // GIVEN
        let testGameEntity = GXGameEntity(id: 0, name: "TESTGAME", backgroundImage: nil, genres: [], metacritic: nil)
        favouritesRepository.addFavourite(game: testGameEntity, completion: {})
        
        // WHEN
        viewModel.inputs.fetchFavouriteList()
        
        // THEN
        XCTAssertTrue(viewModel.outputs.numberOfItems == 1)
        let item = viewModel.outputs.itemForIndex(0)
        XCTAssertNotNil(item)
        let unwrappedItem = try XCTUnwrap(item)
        XCTAssertEqual(unwrappedItem, GXGamePresentation.init(entity: testGameEntity))
    }
    
}
