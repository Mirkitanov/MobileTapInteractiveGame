//
//  VideoLooperView.swift
//  MobileTapInteractive
//
//  Created by Админ on 07.07.2022.
//

import AVFoundation
import UIKit

class VideoLooperView: UIView {
    
    let videoPlayerView = VideoPlayerView()
    
    private var queuePlayer = AVQueuePlayer()
    
        override init(frame: CGRect) {
        
        super.init(frame: .zero)
        
        initilizePayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(videoPlayerView)
        videoPlayerView.frame = bounds
    }
    
    private func initilizePayer() {
        videoPlayerView.player = queuePlayer

    }
    
    func showVideo (from videoURL: URL) {
        
        DispatchQueue.main.async {
            
            let asset = AVURLAsset(url: videoURL)
            
            let item = AVPlayerItem(asset: asset)
            
            self.queuePlayer.removeAllItems()
            
            self.queuePlayer.insert(item, after: nil)
            
            self.videoPlayerView.playerLayer.videoGravity = .resizeAspectFill
            
            self.queuePlayer.play()
        }
    }
}
