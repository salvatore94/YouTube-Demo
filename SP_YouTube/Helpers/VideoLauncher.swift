//
//  VideoLauncher.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class VideoLauncher: NSObject {
    
    private var videoViewLeadingConstraint: NSLayoutConstraint!
    private var videoViewTopConstraint: NSLayoutConstraint!
    
    
    private let videoView = VideoView()
    
    func showViewPlayer() {
        let optionalWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
        guard let window = optionalWindow else {return}
        

        window.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        
        videoViewLeadingConstraint = videoView.leadingAnchor.constraint(equalTo: window.leadingAnchor)
        videoViewTopConstraint = videoView.topAnchor.constraint(equalTo: window.topAnchor)
        
        videoViewTopConstraint.constant = window.frame.height - 90
        videoViewLeadingConstraint.constant = window.frame.width - 160
        
        videoViewTopConstraint.isActive = true
        videoViewLeadingConstraint.isActive = true
        
        window.layoutIfNeeded()
        
        //At this point we have player on the bottom right corner
        //so we could start the animation
        videoViewTopConstraint.constant = 0
        videoViewLeadingConstraint.constant = 0
        
        let animator = UIViewPropertyAnimator(duration: 0.7, curve: .easeOut) {
            window.layoutIfNeeded()
            self.videoView.contentView.alpha = 1.0
        }
        
        animator.addCompletion { (finished) in
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
        }
        
        animator.startAnimation()
        
    }
}


