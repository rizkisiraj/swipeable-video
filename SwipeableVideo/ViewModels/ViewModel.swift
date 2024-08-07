//
//  ViewModel.swift
//  SwipeableVideo
//
//  Created by Rizki Siraj on 06/08/24.
//

import Foundation
import SwiftUI
import AVKit

class VideoPlayerManager: ObservableObject {
    @Published var currentVideo: AVPlayer?
    var players: [Int: AVPlayer] = [:]
    @Published var currentIndex = 0
    var videos: [Video] = Video.videosDummy
    private var observers: [NSKeyValueObservation] = []
    
    func getPlayer(for index: Int) -> AVPlayer {
            if let player = players[index] {
                return player
            } else {
                let videoURL = URL(string: videos[index].videoURL)!
                let asset = AVAsset(url: videoURL)
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.preferredForwardBufferDuration = 5
                let player = AVPlayer(playerItem: playerItem)
                players[index] = player
                return player
            }
    }

    func preloadVideos() {
        let start = max(0, currentIndex - 1)
        let end = min(videos.count-1, currentIndex + 1)
        
        cleanUpObservers()
        
        for i in start...end {
            let player = getPlayer(for: i)
            let observer = player.currentItem!.observe(\.status, options: [.new, .old], changeHandler: { (playerItem, change) in
                if playerItem.status == .readyToPlay {
                    self.players[i]?.preroll(atRate: 1)
                }
            })
            
            observers.append(observer)
        }
        
    }
    
    func cleanUpObservers() {
        observers.forEach { $0.invalidate() }
        observers.removeAll()
    }

    func playVideo(at index: Int) {
        currentIndex = index
        let player = getPlayer(for: index)
        player.seek(to: .zero)
        player.play()
        preloadVideos()
    }

    func moveToNextVideo() {
        let player = getPlayer(for: currentIndex)
        player.pause()
        currentIndex += 1
        if currentIndex < videos.count {
            playVideo(at: currentIndex)
        } else {
            currentIndex = videos.count - 1
        }
    }

    func moveToPreviousVideo() {
        let player = getPlayer(for: currentIndex)
        player.pause()
        currentIndex -= 1
        if currentIndex >= 0 {
            playVideo(at: currentIndex)
        } else {
            currentIndex = 0
        }
    }
}
