//
//  VideoManger.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/24/25.
//
import AVFoundation

class VideoManager {
    static let shared = VideoManager()
    private var currentPlayer: AVPlayer?
    
    private init() {}

    func playVideo(player: AVPlayer) {
        currentPlayer?.pause()
        currentPlayer = player
        currentPlayer?.play()
    }

    func reset() {
        currentPlayer?.pause()
        currentPlayer = nil
    }
    
    func stopVideo() {
        currentPlayer?.pause()
    }
}
