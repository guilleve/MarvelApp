//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Vergara, Guillermo on 04/12/2021.
//

import Foundation

class CharacterListViewModel {
    
    private let service: CharactersServiceApi
    private var characters = [Character]()
    private var currentPage = -1
    private var characterName: String?
    private let pageSize = 10
    private let coordinator: CharacterCoordinatorType
    var isLoading = false
    
    init(service: CharactersServiceApi = CharactersService(urlSession: URLSession.shared),
         coordinator: CharacterCoordinatorType) {
        self.service = service
        self.coordinator = coordinator
        self.characters = [Character]()
    }
    
    var characterCount: Int {
        characters.count
    }
    
    func characterAtIndex(_ index: Int) -> Character {
        return characters[index]
    }
    
    private func getCharacterList(with name: String? = nil,
                                  onSuccess: @escaping (Int) -> Void,
                                  onFail: @escaping (ServiceError) -> Void) {
        isLoading = true
        service.get(page: currentPage, pageSize: pageSize, name: characterName) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.characters.append(contentsOf: response.data.results ?? [])
                onSuccess(response.data.results?.count ?? 0)
            case .failure(let error):
                onFail(error)
            }
        }
    }
    
    func loadCharacters(with name: String? = nil, onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void) {
        currentPage = 0
        characterName = name
        characters = [Character]()
        getCharacterList(onSuccess: onSuccess, onFail: onFail)
    }
    
    func loadMore(onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void) {
        currentPage += 1
        getCharacterList(onSuccess: onSuccess, onFail: onFail)
    }
    
    func detailForCharacter(at indexPath: IndexPath) {
        coordinator.detail(of: characters[indexPath.row])
    }
    
    func reset() {
        currentPage = -1
        characterName = nil
    }
}
