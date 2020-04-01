//
//  FeedCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
    private let cellID = "FeedCollectionViewCellID"
    
    var videos : [Video] = []
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        fetchVideos()
        
        addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func fetchVideos() {
        VideoFetcher.shared.fetch(type: .home) { (fetchedVideos) in
            DispatchQueue.main.async {
                self.videos = fetchedVideos
                self.collectionView.reloadData()
            }
        }
    }
}


extension FeedCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //We calculate cell's height based on preview size
        //To keep correct aspect ratio for preview we need to give 9/16 of it's width
        //Of course the accessory view height needs to be added
        
        //Padding: top=16, bottom=44+8+16, left=right=16
        let previewHeight : CGFloat = (frame.width - 32) * 9/16
        let height : CGFloat = previewHeight + 92
        
        return CGSize(width: frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
