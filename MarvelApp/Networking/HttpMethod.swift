//
//  HttpMethod.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}
