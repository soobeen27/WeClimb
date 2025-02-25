//
//  VideoManger.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/24/25.
//
import AVFoundation

class VideoManager {
    static let shared = VideoManager()
    private var currentPlayer: AVQueuePlayer?
    
    private init() {}

    func playNewVideo(player: AVQueuePlayer) {
        currentPlayer?.pause()
        currentPlayer = player
        currentPlayer?.play()
    }
    
    func playCurrentVideo() {
        currentPlayer?.play()
    }

    func reset() {
        currentPlayer?.pause()
        currentPlayer = nil
    }
    
    func stopVideo() {
        currentPlayer?.pause()
    }
    
    private var uploadPlayer: AVQueuePlayer?
    
    func UploadPlayNewVideo(player: AVQueuePlayer) {
        uploadPlayer?.pause()
        uploadPlayer = player
        uploadPlayer?.play()
    }
    
    func UploadPlayCurrentVideo() {
        uploadPlayer?.play()
    }

    func UploadReset() {
        uploadPlayer?.pause()
        uploadPlayer = nil
    }
    
    func UploadStopVideo() {
        uploadPlayer?.pause()
    }
}
