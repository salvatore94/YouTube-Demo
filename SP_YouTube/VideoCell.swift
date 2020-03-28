//
//  HomeControllerCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 27/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class VideoCell : UICollectionViewCell {
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .purple
        return label
    }()
    
    let subTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        let lineLayer = CAShapeLayer()
        lineLayer.fillColor = UIColor.darkGray.cgColor
        
        //Fixme: Why I had to multiply width for scale?
        lineLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*UIScreen.main.scale, height: 1)
        lineLayer.path = CGPath(rect: lineLayer.frame, transform: nil)
        layer.addSublayer(lineLayer)
        lineLayer.position = CGPoint(x: 0, y: bounds.maxY - 1)
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension VideoCell {
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: userProfileImageView.topAnchor, constant: -8).isActive = true
        
        userProfileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.widthAnchor.constraint(equalTo: userProfileImageView.heightAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        subTitleLabel.bottomAnchor.constraint(equalTo: userProfileImageView.bottomAnchor).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}



extension UIView {
    func makeConstraints(from anchorView: UIView, withPadding top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: anchorView.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: anchorView.trailingAnchor, constant: trailing).isActive = true
        topAnchor.constraint(equalTo: anchorView.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: bottom).isActive = true
    }
}
