//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit

class LibraryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let toggleView = LibraryToggleView()
    private var viewModel = LibraryViewModel()
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumVC = LibraryAlbumViewController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55)
        
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 50)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        
        toggleView.delegate = self
        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
        addChildren()
        
        updateBarButtons()
    }
    
    // MARK: - Fetching Data
    
    private func fetchData() {
          viewModel.fetchData { [weak self] success in
              guard let self = self else { return }
              DispatchQueue.main.async {
                  if success {
                      self.addChildren()
                  }
              }
          }
      }
    
    // MARK: - Functions
    
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd() {
        playlistsVC.showCreatePlaylistAlert()
    }
    
    private func addChildren() {
        addChild(playlistsVC) // Allows all lifecycles to run within the scrollview
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumVC) // Allows all lifecycles to run within the scrollview
        scrollView.addSubview(albumVC.view)
        albumVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumVC.didMove(toParent: self)
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100) {
            toggleView.update(for: .album)
        } else {
            toggleView.update(for: .playlist)
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
}
