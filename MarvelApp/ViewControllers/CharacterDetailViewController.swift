//
//  CharacterDetailViewController.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 08/12/2021.
//

import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var image: NetworkImageLoader!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    var viewModel: CharacterDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        setupGradient()
    }
    
    func configureScreen() {
        title = viewModel.name
        titleLabel.text = viewModel.description
        guard let url = viewModel.imageUrl else { return }
        image.loadImage(from: url) { _ in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        activityIndicator.startAnimating()
    }
    
    private func setupGradient() {
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.3, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
    }
}

extension CharacterDetailViewController {
    static func instantiate(with viewModel: CharacterDetailViewModel) -> CharacterDetailViewController {
        let viewController = CharacterDetailViewController.instantiate(from: .Characters)
        viewController.viewModel = viewModel
        return viewController
    }
}
