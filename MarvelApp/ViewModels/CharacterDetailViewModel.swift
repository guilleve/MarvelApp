//
//  CharacterDetailViewModel.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 09/12/2021.
//

import Foundation

class CharacterDetailViewModel {
    
    private let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    var imageUrl: URL? {
        return character.thumbnail?.url
    }
    
    var description: String {
        character.description ?? "No description"
    }
    
    var name: String {
        character.name ?? "No name"
    }
}
