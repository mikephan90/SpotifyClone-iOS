//
//  LibraryAlbumViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/9/24.
//

import UIKit

class LibraryAlbumViewController: UIViewController {
    
    // MARK: - Properties
    
    var albums = [Album]()
    var viewModel = LibraryAlbumViewModel()
    
    // Return to the caller, a playlist
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: 0, y: 0, width: 160, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { _ in
            // Everytime a playlist is added, we want to fetch data again
            self.fetchData()
        })
    }
    
    private func updateUI() {
        if albums.isEmpty {
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    // MARK: - Fetching Data
    
    private func fetchData() {
        albums.removeAll()
        viewModel.fetchData { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.albums = self.viewModel.albums
                    self.updateUI()
                }
            }
        }
    }
    
    func setUpNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.configure(with: ActionLabelViewViewModel(text: "You don't have any saved albums yet", actionTitle: "Browse"))
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension LibraryAlbumViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "-",
            imageUrl: URL(string: album.images.first?.url ?? "")
        ))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
