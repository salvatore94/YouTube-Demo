//
//  VideoPlayerView.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private var playerLayer: AVPlayerLayer?
    
    public var controllerOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayer()
        backgroundColor = .black
        
        addSubview(controllerOverlayView)
        controllerOverlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        controllerOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        controllerOverlayView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        controllerOverlayView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        controllerOverlayView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: controllerOverlayView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: controllerOverlayView.centerYAnchor).isActive = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension VideoPlayerView {
    private func setupPlayer() {
        //let urlString = "https://firebasestorage.googleapis.com/v0/b/fir-assets-7f422.appspot.com/o/test.mp4?alt=media&token=73bd3d52-bcf0-4ffb-8210-a6e5dab710d7"
        
        let urlString = "https://raw.githubusercontent.com/salvatore94/SP_YouTube_assets/master/videos/test.mp4?raw=true"
        if let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            layer.addSublayer(playerLayer!)
            
            player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.loadedTimeRanges), options: .new, context: nil)
            player.play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AVPlayer.currentItem.loadedTimeRanges) {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
