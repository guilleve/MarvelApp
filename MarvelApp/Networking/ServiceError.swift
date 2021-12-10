//
//  ServiceError.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

enum ServiceError: Error {
    case requestError(Error)
    case decodingError
    case noDataError
    case responseFailError
}

extension ServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .requestError(_):
            return "Request error."
        case .decodingError:
            return "There has been an error decoding data response."
        case .noDataError:
            return "No data."
        case .responseFailError:
            return "Failed response."
        }
    }
}
