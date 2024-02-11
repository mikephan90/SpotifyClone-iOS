//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageUrl: URL? { get }
}

#warning("This playback is all messed up, fix the buttons and playlist")
final class PlaybackPresenter {
    
    // MARK: - Properties
    
    static let shared = PlaybackPresenter()
    
    var playerVC: PlayerViewController?
    
    var audioPlayer: AVPlayer?
    
    var playerQueue: AVQueuePlayer?
    
    private var track: AudioTrack?  /// Keep track of reference of track
    
    private var tracks = [AudioTrack]()
    
    private var currTrack: AudioTrack?
    
    var currentTrackIndex = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks[currentTrackIndex]
        }
        currentTrackIndex = 0 /// If track reaches end of playlist/album, reset to first
        return nil
    }
    
    // MARK: - Functions
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        
        guard let url = URL(string: track.preview_url ?? "")  else { return }
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.volume = getSystemOutputVolume()
        
        self.track = track
        self.tracks = []
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.audioPlayer?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack], at index: Int) {
        currentTrackIndex = index
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else { return nil }
            return AVPlayerItem(url: url)
        }))
        
        if currentTrackIndex >= 0 && currentTrackIndex < tracks.count {
            // Go to the desired item in the player queue
            for _ in 0..<currentTrackIndex {
                playerQueue?.advanceToNextItem()
            }
            
            // Play the player queue
            playerQueue?.play()
        }
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.playerQueue?.play()
        }
        
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        audioPlayer?.volume = value
    }
    
    func didTapPlayPause() {
        if let audioPlayer = audioPlayer {
            if audioPlayer.timeControlStatus == .paused {
                audioPlayer.play()
            } else if audioPlayer.timeControlStatus == .playing {
                audioPlayer.pause()
            }
        } else if let audioPlayer = playerQueue {
            if audioPlayer.timeControlStatus == .paused {
                audioPlayer.play()
            } else if audioPlayer.timeControlStatus == .playing {
                audioPlayer.pause()
            }
        }
    }
    
    func didTapNext() {
        guard !tracks.isEmpty else {
            audioPlayer?.pause()
            return
        }
        
        guard let player = playerQueue else {
            return
        }
        
        currentTrackIndex += 1
        
        if currentTrackIndex >= 0 && currentTrackIndex < tracks.count {
            print(player.items())
            
            player.advanceToNextItem()
            playerVC?.refreshUI()
            
            player.play()
        } else {
            currentTrackIndex = 0

            player.pause()
            player.removeAllItems()
            
            playerQueue = AVQueuePlayer(items: tracks.compactMap { track in
                guard let url = URL(string: track.preview_url ?? "") else { return nil }
                return AVPlayerItem(url: url)
            })
            
            player.play()
            playerVC?.refreshUI()
        }
    }
    
    func didTapBack() {
        if tracks.isEmpty {
            audioPlayer?.pause()
            audioPlayer?.play()
        } else if let player = playerQueue {
        
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
