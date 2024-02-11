//
//  LibraryPlaylistsViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/9/24.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    // MARK: - Properties
    
    var playlists = [Playlist]()
    var viewModel = LibraryPlaylistsViewModel()
    var selectionHandler: ((Playlist) -> Void)? // Return to the caller, a playlist
    
    // MARK: - Views
    
    private let noPlaylistView = ActionLabelView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: 160, height: 150)
        tableView.frame = view.bounds
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpNoPlaylistView()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapClose)
            )
        }
    }
    
    private func updateUI() {
        noPlaylistView.isHidden = !viewModel.isPlaylistEmpty
        tableView.isHidden = viewModel.isPlaylistEmpty
        tableView.reloadData()
    }
    
    // MARK: - Fetching Data
    
    private func fetchData() {
        viewModel.fetchData { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.playlists = self.viewModel.playlists
                    self.updateUI()
                }
            }
        }
    }
    
    // MARK: - Functions
    
    func setUpNoPlaylistView() {
        view.addSubview(noPlaylistView)
        noPlaylistView.configure(with: ActionLabelViewViewModel(
            text: viewModel.noPlaylistsText,
            actionTitle: "Create"))
    }
    
    func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Plalists", message: "Enter playlist name.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlists..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    self?.fetchData()
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}

extension LibraryPlaylistsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewModel(title: playlist.name, subtitle: playlist.owner.display_name, imageUrl: URL(string: playlist.images.first?.url ?? "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let playlist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
