//
//  ApplicationCoordinator.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 09/12/2021.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let window: UIWindow
    let characterCoordinator: CharacterCoordinator
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        characterCoordinator = CharacterCoordinator(navigationController: navigationController)
    }
    
    func start() {
        window.rootViewController = navigationController
        characterCoordinator.start()
        window.makeKeyAndVisible()
    }
}
