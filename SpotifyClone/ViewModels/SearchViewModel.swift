//
//  SearchViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation
import UIKit

protocol SearchResultViewModelDelegate: AnyObject {
    func showResult(_ controller: UIViewController)
    func didTapResult(_ result: SearchResult)
}

class SearchViewModel: SearchResultViewModelDelegate {

    // MARK: - Properties
    
    weak var searchResultDelegate: SearchResultViewModelDelegate?
    private let apiCaller = APICaller.shared
    
    // MARK: - Methods
    
    func fetchData(completion: @escaping (Result<[Category], Error>) -> Void) {
        var genreCategories: [Category] = []
        apiCaller.getCategories { result in
            switch result {
            case .success(let categories):
                genreCategories = categories
                completion(.success(genreCategories))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func showResult(_ controller: UIViewController) {
        searchResultDelegate?.showResult(controller)
    }
    
    func didTapResult(_ result: SearchResult) {
        searchResultDelegate?.didTapResult(result)
    }
    
    func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        APICaller.shared.search(with: query) { result in
            completion(result)
        }
    }
}
