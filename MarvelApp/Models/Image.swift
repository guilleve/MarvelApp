//
//  Image.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 08/12/2021.
//

import Foundation

struct Image: Codable {
    let path: String?
    let ext: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}

extension Image {
    
    var url: URL? {
        if let path = path, let ext = ext {
            return URL(string: "\(path).\(ext)")
        } else {
            return nil
        }
    }
}
