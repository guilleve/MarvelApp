//
//  CharacterDataWrapper.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

struct CharacterDataWrapper: Codable {
    var data: CharacterDataContainer
}

struct CharacterDataContainer: Codable {
    var results: [Character]?
}
