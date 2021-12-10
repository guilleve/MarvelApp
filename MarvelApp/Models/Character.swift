//
//  Character.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 07/12/2021.
//

import Foundation

struct Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Image?
}
