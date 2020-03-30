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
            if let thumbnailImageTitle = video?.thumbnailImageName {
                thumbnailImageView.image = UIImage(named: thumbnailImageTitle)
            }
            titleLabel.text = video?.title
            
            if let profileImage = video?.channel?.profileImageName {
                userProfileImageView.image = UIImage(named: profileImage)
            }
            
            var subTitleText = ""
            if let channelName = video?.channel?.name {
                subTitleText.append(contentsOf: channelName)
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let numberOfViews = video?.numbersOfViews,
                let formatted = numberFormatter.string(from: numberOfViews){
                subTitleText.append(contentsOf: " - \(formatted)")
            }
            
            if let uploadDate = video?.uploadDate {
                subTitleText.append(contentsOf: " - \(uploadDate)")
            }
        
            subTitleLabel.text = subTitleText
            
            
            //adapting titleLabel height to wrap long titles
            if let title = video?.title {
                let size = CGSize(width: frame.width - 88, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
                
                titleLabelHeightConstraint.constant = estimatedRect.size.height > 20 ? 44 :  20
                self.setNeedsLayout()
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.animationImages = UIImage.gif(named: "lp")
        imageView.image = imageView.animationImages?.first
        imageView.animationDuration = 3
        imageView.animationRepeatCount = 1
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 44/2
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "lp_profile")
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Linkin Park - What i've done"
        label.numberOfLines = 2
        return label
    }()
    
    let subTitleLabel : UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LinkinParkVEVO • 1,604,684,607 views • 12 years ago"
        label.textColor = UIColor.lightGray
        label.isUserInteractionEnabled = false
        label.contentInset = .init(top: -8, left: -4, bottom: 0, right: 0)
        return label
    }()
    
    @objc func previewTap() {
        thumbnailImageView.startAnimating()
    }
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCell.previewTap))
        addGestureRecognizer(tap)
    }
}




extension UIImage {
    static func gif(named: String) -> [UIImage]? {
        guard let path = Bundle.main.path(forResource: named, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
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
