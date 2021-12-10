//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

enum MarvelAPI {
        
    enum Constants {
        static let baseURL = "https://gateway.marvel.com"
        static let apiKey = "4b6511d0650d461037d6786ab4fe2f1b"
        static let privateKey = "0572f43bc523557cb16fb5a6b931523ce96cb423"
    }
    
    enum ParamKey {
        static let ts = "ts"
        static let hash = "hash"
        static let apikey = "apikey"
    }
        
    case charactersList
    case character(id: Int)
    
    var method: String {
        switch self {
        case .charactersList, .character:
            return "GET"
        }
    }
    
    var endpointUrl: String {
        switch self {
        case .charactersList:
            return Constants.baseURL + "/v1/public/characters"
        case .character(let id):
            return Constants.baseURL + "/v1/public/characters/\(id)"
        }
    }
    
    var url: URL {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(Constants.privateKey)\(Constants.apiKey)".MD5()
        var components = URLComponents(url: URL(string: endpointUrl)!, resolvingAgainstBaseURL: true)
        let commonQueryItems = [
            URLQueryItem(name: ParamKey.ts, value: timestamp),
            URLQueryItem(name: ParamKey.hash, value: hash),
            URLQueryItem(name: ParamKey.apikey, value: Constants.apiKey)
        ]
        components?.queryItems = commonQueryItems
        return components!.url!
    }
}
