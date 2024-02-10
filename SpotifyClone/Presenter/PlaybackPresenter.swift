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
    
    private var tracks =  [AudioTrack]()
    
    var currentTrackIndex = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
            
        } else if let player = self.playerQueue, !tracks.isEmpty {
           
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
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else { return nil }
            return AVPlayerItem(url: url)
        }))
        
        playerQueue?.volume = getSystemOutputVolume()
        playerQueue?.play()
        
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
        if tracks.isEmpty {
            // Not playlist or album
            audioPlayer?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            currentTrackIndex += 1
            playerVC?.refreshUI()
        }
    }
    
    // TODO: FIX THIS TO GO BACK TO PREVIOUS SONG. KEEP TRACK OF LAST URL
    func didTapBack() {
        if tracks.isEmpty {
            audioPlayer?.pause()
            audioPlayer?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
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
