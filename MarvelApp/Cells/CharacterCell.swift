//
//  CharacterCell.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 07/12/2021.
//

import Foundation
import UIKit

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var image: NetworkImageLoader!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupCellLayout()
        setupGradient()
    }
    
    func configure(character: Character) {
        titleLabel.text = character.name
        guard let url = character.thumbnail?.url else { return }
        image.loadImage(from: url) { _ in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        image.image = nil
    }
    
    private func setupCellLayout() {
        clipsToBounds = true
        layer.cornerRadius = 8.0
        layer.backgroundColor = UIColor.clear.cgColor
        layer.masksToBounds = false
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
    private func setupGradient() {
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.3, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
    }
}
