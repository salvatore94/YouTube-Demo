//
//  HomeControllerCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 27/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class VideoCell : BaseCell {
    var video: Video? {
        didSet {
            guard let video = video else {
                thumbnailImageView.image = nil
                userProfileImageView.image = nil
                titleLabel.text = nil
                subTitleLabel.text = ""
                return
            }
            titleLabel.text = video.title

            
            guard let thumbnailImageViewURL = URL(string: video.thumbnailImageName) else {return}
            ImageLoader.image(for: thumbnailImageViewURL) { (image) in
                self.thumbnailImageView.image = image
            }
            
        
            guard let userProfileImageViewURL = URL(string: video.channel.profileImageName) else {return}
            ImageLoader.image(for: userProfileImageViewURL) { (image) in
                self.userProfileImageView.image = image
            }
            
            
            var subTitleText = ""
            subTitleText.append(contentsOf: video.channel.name)
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let nsNumber = NSNumber(value: video.numbersOfViews)
            if let formatted = numberFormatter.string(from: nsNumber){
                subTitleText.append(contentsOf: " - \(formatted)")
            }
            
            subTitleLabel.text = subTitleText
            
            
            //adapting titleLabel height to wrap long titles
            let size = CGSize(width: frame.width - 88, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: video.title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
            
            titleLabelHeightConstraint.constant = estimatedRect.size.height > 20 ? 44 :  20
            self.setNeedsLayout()
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 44/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let subTitleLabel : UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.isUserInteractionEnabled = false
        label.contentInset = .init(top: -8, left: -4, bottom: 0, right: 0)
        return label
    }()
    
    
    var titleLabelHeightConstraint : NSLayoutConstraint!
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        thumbnailImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 9/16).isActive = true

        userProfileImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.widthAnchor.constraint(equalTo: userProfileImageView.heightAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        titleLabelHeightConstraint.isActive = true
        
        
        subTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        
     
        let lineLayer = CAShapeLayer()
        lineLayer.fillColor = UIColor.lightGray.cgColor
           
        //Fixme: Why I had to multiply width for scale?
        lineLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*UIScreen.main.scale, height: 1)
        lineLayer.path = CGPath(rect: lineLayer.frame, transform: nil)
        layer.addSublayer(lineLayer)
        lineLayer.position = CGPoint(x: 0, y: bounds.maxY - 1)
    }
}
