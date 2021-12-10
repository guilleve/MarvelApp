//
//  MarvelAppTests.swift
//  MarvelAppTests
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import XCTest
@testable import MarvelApp

class CharacterListViewModelTests: XCTestCase {

    var viewModel: CharacterListViewModel!
    var service: CharacterServiceMock!
    var coordinator: MockCoordinator!
    
    override func setUp() {
        service = CharacterServiceMock()
        coordinator = MockCoordinator()
        viewModel = CharacterListViewModel(service: service, coordinator: coordinator)
    }
    
    func testLoadCharactersSuccess() {
        let character = Character(id: 1, name: "super", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        service.characterData = CharacterDataWrapper(data: CharacterDataContainer(results: [character]))
        let expectation = self.expectation(description: #function)
        viewModel.loadCharacters { _ in
            expectation.fulfill()
        } onFail: { _ in }
        waitForExpectations(timeout: 0.1)
    }
    
    func testLoadCharactersFail() {
        service.characterData = nil
        let expectation = self.expectation(description: #function)
        viewModel.loadCharacters { _ in } onFail: { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
    
    func testCharacterCountAndCharacterAtIndex() {
        XCTAssertEqual(viewModel.characterCount, 0)
        let character1 = Character(id: 1, name: "super1", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        let character2 = Character(id: 2, name: "super2", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        service.characterData = CharacterDataWrapper(data: CharacterDataContainer(results: [character1, character2]))
        let expectation = self.expectation(description: #function)
        viewModel.loadCharacters { _ in
            expectation.fulfill()
        } onFail: { _ in }
        waitForExpectations(timeout: 0.1)
        XCTAssertEqual(viewModel.characterCount, 2)
        XCTAssertEqual(viewModel.characterAtIndex(1).name, "super2")
    }
    
    func testLoadMoreSuccess() {
        let character1 = Character(id: 1, name: "super1", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        let character2 = Character(id: 2, name: "super2", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        service.characterData = CharacterDataWrapper(data: CharacterDataContainer(results: [character1, character2]))
        let expectationLoad = self.expectation(description: "Load characters expectation")
        let expectationLoadMore = self.expectation(description: "Load more expectation")
        viewModel.loadCharacters { _ in
            expectationLoad.fulfill()
        } onFail: { _ in }
        wait(for: [expectationLoad], timeout: 0.1)
        XCTAssertEqual(viewModel.characterCount, 2)
        
        let character3 = Character(id: 3, name: "super3", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        let character4 = Character(id: 4, name: "super4", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        service.characterData = CharacterDataWrapper(data: CharacterDataContainer(results: [character3, character4]))
        viewModel.loadMore() { _ in
            expectationLoadMore.fulfill()
        } onFail: { _ in }
        wait(for: [expectationLoadMore], timeout: 0.1)
        XCTAssertEqual(viewModel.characterCount, 4)
        XCTAssertEqual(viewModel.characterAtIndex(3).name, "super4")
    }
    
    func testDetailForCharacterMethod() {
        let character = Character(id: 1, name: "super", description: "some description", thumbnail: Image(path: "path", ext: "ext"))
        service.characterData = CharacterDataWrapper(data: CharacterDataContainer(results: [character]))
        let expectation = self.expectation(description: #function)
        viewModel.loadCharacters { _ in
            expectation.fulfill()
        } onFail: { _ in }
        waitForExpectations(timeout: 0.1)
        viewModel.detailForCharacter(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(coordinator.detailMethodGetCalled)
    }

}


class CharacterServiceMock: CharactersServiceApi {
    var characterData: CharacterDataWrapper?
    func get(page: Int, pageSize: Int, name: String?, completion: @escaping (Result<CharacterDataWrapper, ServiceError>) -> Void) {
        if let data = characterData {
            completion(.success(data))
        } else {
            completion(.failure(.noDataError))
        }
    }
}

class MockCoordinator: CharacterCoordinatorType {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    var detailMethodGetCalled = false
    
    func start() {}
    
    func detail(of character: Character) {
        detailMethodGetCalled = true
    }
}
