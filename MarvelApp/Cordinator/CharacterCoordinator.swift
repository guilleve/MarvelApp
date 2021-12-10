//
//  CharacterCoordinator.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 09/12/2021.
//

import Foundation
import UIKit

protocol CharacterCoordinatorType: AnyObject, Coordinator {
    func detail(of character: Character)
}

class CharacterCoordinator: CharacterCoordinatorType {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var controller: CharacterListViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CharacterListViewController.instantiate(with: CharacterListViewModel(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
        self.controller = viewController
    }
    
    func detail(of character: Character) {
        let detailViewController = CharacterDetailViewController.instantiate(with: CharacterDetailViewModel(character: character))
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
