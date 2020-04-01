//
//  TrendingCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
        VideoFetcher.shared.fetch(type: .trending) { (fetchedVideos) in
            DispatchQueue.main.async {
                self.videos = fetchedVideos
                self.collectionView.reloadData()
            }
        }
    }
}
