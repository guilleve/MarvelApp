//
//  CharacterListViewController.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var viewModel: CharacterListViewModel!
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"
        controller.searchBar.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MARVEL Characters"
        collectionView.registerCell(of: CharacterCell.self, bundle: nil)
        configureLoadingFooter()
        configureSearchBar()
        loadCharacters()
    }
    
    private func configureLoadingFooter() {
        collectionView.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    @objc private func loadCharacters(with name: String? = nil) {
        loadingIndicator.startAnimating()
        viewModel.loadCharacters(with: name, onSuccess: { [weak self] _ in
            self?.loadingIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }, onFail: { [weak self] error in
            self?.loadingIndicator.stopAnimating()
            self?.showError(error: error)
        })
    }
    
    private func loadNextPage() {
        footerView.startAnimating()
        viewModel.loadMore(
            onSuccess: { [weak self] newDataCount in
                guard let self = self else { return }
                self.footerView.stopAnimating()
                let startIndex = self.viewModel.characterCount - newDataCount
                let endIndex = startIndex + newDataCount
                let indexesToAdd = Array(startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                self.collectionView.performBatchUpdates({
                    self.collectionView.setContentOffset(self.collectionView.contentOffset, animated: false)
                    self.collectionView.insertItems(at:indexesToAdd)
                }, completion: nil)
            },
            onFail: { [weak self] error in
                self?.footerView.stopAnimating()
                self?.showError(error: error)
            })
    }
    
    private func showError(error: Error) {
        showAlert("Error!", message: "There has been an error when retrieving new data. Description: \(error.localizedDescription)")
    }
}

extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: (collectionViewSize/2) - 20, height: collectionViewSize/2)
    }
}

extension CharacterListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characterCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CharacterCell.self, for: indexPath)
        cell.configure(character: viewModel.characterAtIndex(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == viewModel.characterCount && !viewModel.isLoading {
            loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.detailForCharacter(at: indexPath)
    }

}

extension CharacterListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        loadCharacters(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.reset()
        collectionView.reloadData()
        loadCharacters()
    }
}

extension CharacterListViewController {
    static func instantiate(with viewModel: CharacterListViewModel) -> CharacterListViewController {
        let viewController = CharacterListViewController.instantiate(from: .Characters)
        viewController.viewModel = viewModel
        return viewController
    }
}
