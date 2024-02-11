//
//  AlbumViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import UIKit

class AlbumViewController: UIViewController {
    
    // MARK: - Properties
    
    // public var fromUserAlbus
    private let album: Album
    private var viewModel: AlbumViewModel
    private var collectionView: UICollectionView!
    private var tracks = [AudioTrack]()
    
    // Need to display this album depending on where we are coming from. see isOwner in playlist
    
    // MARK: - Views
    
    private lazy var shareAlbumButton: UIBarButtonItem = {
       let button = UIBarButtonItem(
        barButtonSystemItem: .action,
        target: self,
        action: #selector(didTapShare))
        
        return button
    }()
    
    private lazy var saveAlbumButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.down"),
            style: .done,
            target: self,
            action: #selector(didTapActions)
        )
        
        return button
    }()
    
    
    // MARK: - Init
    
    init(album: Album) {
        self.album = album
        self.viewModel = AlbumViewModel(album: album)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        title = album.name
        view.backgroundColor = .systemBackground
        collectionView = setupCollectionView()
        view.addSubview(collectionView)
       
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
        )
        
        collectionView.register(
            AlbumTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier
        )
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItems = [saveAlbumButton, shareAlbumButton]
    }
    
    private func setupCollectionView() -> UICollectionView {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(60)
                    ),
                    subitems: Array(repeating: item, count: 1)
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            })
        )
    }
    
    private func updateUI(with model: AlbumDetailsResponse) {
        let tracks = model.tracks.items
        let trackViewModels = model.tracks.items.compactMap { track -> AlbumCollectionViewCellViewModel? in
            
            return  AlbumCollectionViewCellViewModel(
                name: track.name,
                artistName: track.artists.first?.name ?? "-"
            )
        }
        
        self.tracks = tracks
        self.viewModel.viewModels = trackViewModels
        
        collectionView.reloadData()
    }
    
    // MARK: - Functions
    
    private func fetchData() {
        viewModel.fetchData(album: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    @objc func didTapActions() {
        let actionSheet = UIAlertController(title: album.name, message: "Actions", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self]  _ in
            guard let sself = self else { return }
            APICaller.shared.saveAlbum(album: sself.album) { success in
                // Add alert to confirm saved
                HapticsManager.shared.vibrate(for: .success)
                if success {
                    NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
                }
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: album.external_urls["spotify"] ?? "") else {
            return
        }
        
        // Add share functionality to top nav bar
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? PlaylistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
                let headerViewModel = PlaylistHeaderViewViewModel(
                    name: album.name,
                    ownerName: album.artists.first?.name,
                    description: "Release Date: \(String.formattedDate(string: album.release_date))",
                    artworkUrl: URL(string: album.images.first?.url ?? "")
                )
                header.configure(with: headerViewModel)
                header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        
        // Create a copy of the immutable 'track' to pass album
        var trackMutable = track
        trackMutable.album = self.album
        let trackWithAlbum: AudioTrack = trackMutable
        
        PlaybackPresenter.shared.startPlayback(from: self, track: trackWithAlbum)
    }
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum, at: 0)
    }
}
