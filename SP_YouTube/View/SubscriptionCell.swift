//
//  SubscriptionCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        VideoFetcher.shared.fetch(type: .subscription) { (fetchedVideos) in
            DispatchQueue.main.async {
                self.videos = fetchedVideos
                self.collectionView.reloadData()
            }
        }
    }
}
