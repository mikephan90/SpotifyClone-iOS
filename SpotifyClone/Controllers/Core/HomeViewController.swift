//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit
import SK

class HomeViewController: UIViewController {
    
    // MARK: - Enum
    
    enum BrowseSectionType {
        case newReleases(viewModels: [NewReleasesCellViewModel])
        case featuredPlaylists(viewModels: [PlaylistCellViewModel])
        case recommendedTracks(viewModels: [TrackCellViewModel])
        
        var title: String {
            switch self {
            case .newReleases: return "New Release Albums"
            case .featuredPlaylists: return "Featured Playlists"
            case .recommendedTracks: return "Recommended"
            }
        }
    }
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    private var viewModel = HomeViewModel()
    private var sections = [BrowseSectionType]()
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return HomeViewController.createSectionLayout(section: sectionIndex)
            }
        )
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.register(
            NewReleasesCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(
            PlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.register(
            TrackCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        view.addSubview(spinner)
    }
    
    private func configureModels() {
        sections.removeAll()
        sections.append(.newReleases(viewModels: newAlbums.compactMap {
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkUrl: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-"
            )
        }))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap {
            return PlaylistCellViewModel(
                name: $0.name,
                artworkUrl: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name
            )
        }))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap {
            return TrackCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "",
                artworkUrl: URL(string: $0.album?.images.first?.url ?? "")
            )
        }))
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        let itemHeightFraction: CGFloat
        let itemWidth: NSCollectionLayoutDimension
        let itemCount: Int
        let orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
        
        switch section {
        case 0:
            itemHeightFraction = 0.33
            itemWidth = .fractionalWidth(0.9)
            itemCount = 3
            orthogonalScrollingBehavior = .groupPaging
        case 1:
            itemHeightFraction = 1
            itemWidth = .fractionalWidth(0.7)
            itemCount = 1
            orthogonalScrollingBehavior = .continuous
        case 2:
            itemHeightFraction = 1.0 / 4.0
            itemWidth = .fractionalWidth(1.0)
            itemCount = 1
            orthogonalScrollingBehavior = .none
        default:
            itemHeightFraction = 1.0 / 3.0
            itemWidth = .fractionalWidth(1.0)
            itemCount = 3
            orthogonalScrollingBehavior = .none
        }
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(itemHeightFraction)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 12, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: itemWidth,
                heightDimension: .absolute(350)
            ),
            subitems: Array(repeating: item, count: itemCount)
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        section.boundarySupplementaryItems = supplementaryViews
        
        return section
    }
    
    // MARK: - Data Fetching
    
    private func fetchData() {
        spinner.startAnimating()
        viewModel.fetchData { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                switch result {
                case .success(let data):
                    self.newAlbums = data.0
                    self.playlists = data.1
                    self.tracks = data.2
                    self.configureModels()
                    self.collectionView.reloadData()
                case .failure(let error):
                    // Handle error
                    print(error.localizedDescription)
                }
            }
        }
    }
   
    // MARK: -  Functions
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this to a playlist?",
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                // Pass back playlist to the caller
                vc.selectionHandler = { playlist in
                    APICaller.shared.addTrackToPlalist(track: model, playlist: playlist) { success in
                        // Display alert Added to playlist (Name)
                    }
                }
                vc.title = "Select Playlist"
                
                self?.present(vc, animated: true, completion: nil)
            }
        }))
        present(actionSheet, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as? PlaylistCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: viewModels[indexPath.row])
            
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as? TrackCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: viewModels[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        
        return header
    }
}
