//
//  Reusable.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 08/12/2021.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UIView: Reusable {}

extension Reusable where Self: UIView {
    func nib<T: UIView>(_ type: T.Type, bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: type.reuseIdentifier, bundle: bundle)
    }
}

extension Reusable where Self: UICollectionView {
    func registerCell<T: UICollectionViewCell>(of type: T.Type, bundle: Bundle? = nil) {
        register(nib(type, bundle: bundle), forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            return T()
        }
    }
}
