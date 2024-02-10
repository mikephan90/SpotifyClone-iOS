//
//  AudioManger.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/9/24.
//

import Foundation
import AVFoundation

func getSystemOutputVolume() -> Float {
    let audioSession = AVAudioSession.sharedInstance()
    
    do {
        try audioSession.setActive(true)
        let volume = audioSession.outputVolume
        return volume
    } catch {
        print("Error setting audio to device level: \(error.localizedDescription)")
        return 0.0
    }
}
