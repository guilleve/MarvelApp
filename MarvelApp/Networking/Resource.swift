//
//  Resource.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

/**
 Generic struct to represent any loadable resource from any service, it has an urlRequest and a
 parse funcion.
 */
struct Resource<A> {
    var urlRequest: URLRequest
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    
    init(get url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }

    init(get url: URL, params: [String: String]) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems?.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        self.urlRequest = URLRequest(url: urlComponents!.url!)
        self.parse = { data in
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            return try? jsonDecoder.decode(A.self, from: data)
        }
    }
    
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>, cookies: String? = nil, token: String? = nil) {
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.method
        switch method {
        case .get: ()
        case .post(let body):
            self.urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }

}
