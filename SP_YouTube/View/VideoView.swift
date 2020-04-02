//
//  VideoView.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class VideoView : UIView {
    public let player = VideoPlayerView()
    
    public let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(player)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        player.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        player.topAnchor.constraint(equalTo: topAnchor).isActive = true
        player.heightAnchor.constraint(equalTo: player.widthAnchor, multiplier: 9/16).isActive = true
        
        contentView.backgroundColor = .white
        contentView.alpha = 0
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: player.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(VideoView.panHandler(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension VideoView {
    @objc
    func panHandler(_ sender: UIPanGestureRecognizer) {
        let optionalWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
        guard let window = optionalWindow else {return}
        let windowBounds = window.bounds
        let translation = sender.translation(in: window)
        
        //let minSize = CGSize(width: 160, height: 90)
        //we want to keep preview at least 160x90
        let minScale = 90/player.bounds.height
        
        let yScale = 1 - (translation.y - player.bounds.height/2)/frame.height
        var scale = max(minScale, yScale)
        
        scale = min(1, scale)
        let previewHeight = bounds.height * minScale
  
        switch sender.state {
        case .changed:
            if center.y < windowBounds.midY + player.bounds.height/2 {
                center.y = windowBounds.midY + translation.y
                break
            }
            contentView.alpha = 1.0*scale/2
            transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            
            center.x = windowBounds.maxX - frame.width/2
            center.y = windowBounds.maxY - frame.height/2 + (previewHeight - 90)
        case .ended, .cancelled, .failed:
            let scaleThreshold : CGFloat = 0.85
            let shouldReopen = scale > scaleThreshold
            let closedFinalTransform = CGAffineTransform.identity.scaledBy(x: minScale, y: minScale)
            let finalTransform = shouldReopen ? CGAffineTransform.identity : closedFinalTransform
            let finalCenterX = shouldReopen ? windowBounds.midX : windowBounds.maxX - bounds.width*minScale/2
            let finalCenterY = shouldReopen ? windowBounds.midY : windowBounds.maxY - bounds.height*minScale/2 + (previewHeight - 90)
            let finalCenter = CGPoint(x: finalCenterX, y: finalCenterY)
            let finalAlphaForContentView : CGFloat = shouldReopen ? 1 : 0
            let animationDuration : Double = shouldReopen ? 0.3 : 0.5
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: .allowUserInteraction, animations: {
                self.transform = finalTransform
                self.center = finalCenter
                self.contentView.alpha = finalAlphaForContentView
            }, completion: nil)

            
        default:
            break
        }
    }
    
    
}
