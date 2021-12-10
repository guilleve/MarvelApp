//
//  MarvelAPITests.swift
//  MarvelAppTests
//
//  Created by Vergara, Guillermo on 10/12/2021.
//

import Foundation
import XCTest
@testable import MarvelApp

class MarvelAPITests: XCTestCase {
    
    func testMarvelAPIEndpointUrl() {
        XCTAssertEqual(MarvelAPI.charactersList.endpointUrl, "https://gateway.marvel.com/v1/public/characters")
        XCTAssertEqual(MarvelAPI.character(id: 123).endpointUrl, "https://gateway.marvel.com/v1/public/characters/123")
    }
    
    func testMarvelAPIUrlContainsQueryParams() {
        let url = MarvelAPI.charactersList.url
        let components = URLComponents(url: URL(string: url.absoluteString)!, resolvingAgainstBaseURL: true)
        if let queryItems = components?.queryItems {
            let queryItemsNames = queryItems.map({ $0.name })
            XCTAssertTrue(queryItemsNames.contains(MarvelAPI.ParamKey.apikey))
            XCTAssertTrue(queryItemsNames.contains(MarvelAPI.ParamKey.ts))
            XCTAssertTrue(queryItemsNames.contains(MarvelAPI.ParamKey.hash))
        }
    }
}
