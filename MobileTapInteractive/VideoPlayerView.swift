//
//  VideoPlayerView.swift
//  MobileTapInteractive
//
//  Created by Админ on 07.07.2022.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
}

