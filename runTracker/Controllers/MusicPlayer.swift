//
//  MusicPlayer.swift
//  runTracker
//
//  Created by Ihonahan Buitrago on 2/15/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MediaPlayer


class MusicPlayer: NSObject {
    var player = MPMusicPlayerController.systemMusicPlayer()
    var query = MPMediaQuery.songs()
    var currentMediaItem = MPMediaItem()
    
    var isPlaying = false
    
    func setupPlayer(completion:(_ success: Bool) -> Void) {
        self.player.setQueue(with: self.query)
        self.isPlaying = false
        if let items = self.query.items?[0] {
            self.player.nowPlayingItem = items
            completion(true)
        }
        completion(false)
    }
    
    func play() {
        self.player.play()
        self.isPlaying = true
    }
    
    func stop() {
        self.player.stop()
        self.isPlaying = false
    }

}
