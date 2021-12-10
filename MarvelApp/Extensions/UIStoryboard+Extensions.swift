//
//  UIStoryboard+Extensions.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 09/12/2021.
//

import Foundation
import UIKit

public enum AppStoryboard: String {
    case Characters
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
    
    var initialViewController: UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    func viewController<T: UIViewController>(of type: T.Type) -> T {
        return instance.instantiateViewController(withIdentifier: type.storyboardId) as! T
    }
}

extension UIViewController {
    class var storyboardId: String {
        return "\(self)"
    }
}

protocol Instantiatable {}

extension Instantiatable where Self: UIViewController {
    static func instantiate(from appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(of: self)
    }
}

extension UIViewController: Instantiatable {}
