//
//  String+Extension.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 08/12/2021.
//

import Foundation
import CryptoKit

extension String {
    func MD5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
