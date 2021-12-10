//
//  CharactersService.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

protocol CharactersServiceApi {
    func get(page: Int, pageSize: Int, name: String?, completion: @escaping (Result<CharacterDataWrapper, ServiceError>) -> Void)
}

enum CharactersServiceAPIParamKey {
    static let offset = "offset"
    static let limit = "limit"
    static let nameStartsWith = "nameStartsWith"
}

class CharactersService: CharactersServiceApi {
    
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func get(page: Int, pageSize: Int, name: String? = nil, completion: @escaping (Result<CharacterDataWrapper, ServiceError>) -> Void) {
        
        let url = MarvelAPI.charactersList.url
        var params = [CharactersServiceAPIParamKey.offset: "\(page * pageSize)",
                      CharactersServiceAPIParamKey.limit: "\(pageSize)"]
        if let name = name {
            params[CharactersServiceAPIParamKey.nameStartsWith] = name
        }
                      
        let resource = Resource<CharacterDataWrapper>.init(get: url, params: params)
        urlSession.load(resource) { result in
            completion(result)
        }
    }
}
