//
//  SearchResultsViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func showResult(_ controller: UIViewController)
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var sections: [SearchSection] = []
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Functions
    
    func update(with results: [SearchResult]) {
        let artists = results.filter ({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let albums = results.filter ({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let tracks = results.filter ({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        let playlists = results.filter ({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = SearchResultDefaultTableViewModel(
                title: artist.name,
                imageUrl: URL(string: artist.images?.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            
            return cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = SearchResultSubtitleTableViewModel(
                title: album.name,
                subtitle: "",
                imageUrl: URL(string: album.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = SearchResultSubtitleTableViewModel(
                title: track.name,
                subtitle: "",
                imageUrl: URL(string: track.album?.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = SearchResultSubtitleTableViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageUrl: URL(string: playlist.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    

}
