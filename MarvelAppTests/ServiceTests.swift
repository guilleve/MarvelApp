//
//  ServiceTests.swift
//  MarvelAppTests
//
//  Created by Vergara, Guillermo on 10/12/2021.
//

import Foundation
import XCTest
@testable import MarvelApp

class ServiceTests: XCTestCase {
    
    var service: CharactersService!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        self.service = CharactersService(urlSession: session)
    }
    
    func testGetCharacterListService() {
        
        let dataTask = MockURLSessionDataTask()
        let resource = Bundle(for: type(of: self)).url(forResource: "characters", withExtension: "json")

        do {
            let expectedData = try? Data(contentsOf: resource!)
            dataTask.nextData = expectedData
            let url = URL(string: "url.marvel.com")
            dataTask.nextUrlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
            session.nextDataTask = dataTask
            
            var actual: CharacterDataWrapper?
            let expectation = self.expectation(description: "Getting charactet Data")
            service.get(page: 0, pageSize: 5, name: nil) { result in
                switch result {
                case .success(let response):
                    actual = response
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            }
            waitForExpectations(timeout: 0.1, handler: nil)
            XCTAssertNotNil(actual, "actual should not be nil")
            XCTAssertEqual(actual?.data.results?[0].name, "3-D Man")
            XCTAssertEqual(actual?.data.results?[0].id, 1011334)
            XCTAssertEqual(actual?.data.results?[0].description, "")
            XCTAssertEqual(actual?.data.results?[0].thumbnail?.url?.absoluteString, "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
            
            XCTAssertEqual(actual?.data.results?.count, 10)
        }
    }
    
}

class MockURLSession: URLSessionProtocol {

    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url

        completionHandler(nextDataTask.nextData, nextDataTask.nextUrlResponse, nextDataTask.nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    var nextData: Data?
    var nextError: Error?
    var nextUrlResponse: URLResponse?

    func resume() {
        resumeWasCalled = true
    }
}
