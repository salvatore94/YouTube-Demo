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
        indicator.color = .white
        return indicator
    }()
    
    private var playerLayer: AVPlayerLayer?
    
    private let pauseButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let pauseImage = UIImage(named: "pause")
        button.setImage(pauseImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(VideoPlayerView.handlePause), for: .touchUpInside)
        return button
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let playImage = UIImage(named: "play")
        button.setImage(playImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(VideoPlayerView.handlePlay), for: .touchUpInside)
        return button
    }()
    
    private let videoLenghtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private let videoCurrentPositionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var videoSlider : UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(VideoPlayerView.handleSliderValueChange), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.thumbTintColor = .red
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        return slider
    }()
    
    public var controllerOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayer()
        
        addSubview(controllerOverlayView)
        controllerOverlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        controllerOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        controllerOverlayView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        controllerOverlayView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        gradientLayer.frame = controllerOverlayView.frame
        controllerOverlayView.layer.addSublayer(gradientLayer)
        
        controllerOverlayView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: controllerOverlayView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: controllerOverlayView.centerYAnchor).isActive = true

        activityIndicator.startAnimating()
        
        [pauseButton, playButton].forEach { (button) in
            button.isHidden = true
            controllerOverlayView.addSubview(button)
            button.centerXAnchor.constraint(equalTo: controllerOverlayView.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: controllerOverlayView.centerYAnchor).isActive = true
            button.heightAnchor.constraint(equalTo: pauseButton.heightAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        [videoCurrentPositionLabel, videoLenghtLabel].forEach { (label) in
            controllerOverlayView.addSubview(label)
            label.bottomAnchor.constraint(equalTo: controllerOverlayView.bottomAnchor, constant: -2).isActive = true
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            label.widthAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        videoCurrentPositionLabel.leadingAnchor.constraint(equalTo: controllerOverlayView.leadingAnchor, constant: 4).isActive = true
        videoLenghtLabel.trailingAnchor.constraint(equalTo: controllerOverlayView.trailingAnchor, constant: -4).isActive = true
        
        
        controllerOverlayView.addSubview(videoSlider)
        videoSlider.bottomAnchor.constraint(equalTo: controllerOverlayView.bottomAnchor, constant: -2).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 24).isActive = true
        videoSlider.leadingAnchor.constraint(equalTo: videoCurrentPositionLabel.trailingAnchor, constant: 4).isActive = true
        videoSlider.trailingAnchor.constraint(equalTo: videoLenghtLabel.leadingAnchor, constant: -4).isActive = true

        backgroundColor = .black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerView.handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handlePause() {
        playerLayer?.player?.pause()
        pauseButton.isHidden = true
        playButton.isHidden = false
    }
    
    @objc
    func handlePlay() {
        playerLayer?.player?.play()
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    @objc
    func handleTap() {
        
        controllerOverlayView.isHidden = !controllerOverlayView.isHidden
    }
    
    @objc
    func handleSliderValueChange() {
        let value = Double(videoSlider.value)
       
        if let player = playerLayer?.player,
            let currentItem = player.currentItem {
            let duration = currentItem.duration
            
            let newPos = duration.seconds * value
            let newTime = CMTime(seconds: newPos, preferredTimescale: duration.timescale)
            player.seek(to: newTime) { (completedSeek) in
                
            }
            
        }
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
            
            player.play()
            player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.loadedTimeRanges), options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progressTime) in
                
                if let currentItem = player.currentItem {
                    let totalDuration = currentItem.duration.seconds
                    
                    let currentPos = progressTime.seconds
                    let sliderValue = currentPos/totalDuration
                    self.videoSlider.value = Float(sliderValue)
                    
                    let seconds = String(format: "%02d", Int(currentPos.truncatingRemainder(dividingBy: 60)))
                    let minutes = String(format: "%02d", Int(currentPos/60))
                    self.videoCurrentPositionLabel.text = "\(minutes):\(seconds)"
                }

            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AVPlayer.currentItem.loadedTimeRanges) {
            activityIndicator.stopAnimating()
            controllerOverlayView.backgroundColor = .clear
            pauseButton.isHidden = false
     
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if !self.videoSlider.isTracking {
                    self.controllerOverlayView.isHidden = true
                }
            }
            
            if let player = playerLayer?.player,
                let currentItem = player.currentItem {
                let duration = currentItem.duration.seconds
                let seconds = String(format: "%02d", Int(duration.truncatingRemainder(dividingBy: 60)))
                let minutes = String(format: "%02d", Int(duration/60))
                videoLenghtLabel.text = "\(minutes):\(seconds)"

            }
        }
        
        
    }
}
