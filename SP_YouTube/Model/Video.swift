//
//  Video.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 30/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class Video : NSObject, Decodable {
    
    let thumbnailImageName: String
    let title: String
    let numbersOfViews: Int
    let duration: Int
    //var uploadDate: Date?
    
    let channel: Channel
    
    enum CodingKeys: String, CodingKey {
        case thumbnailImageName = "thumbnail_image_name"
        case numbersOfViews = "number_of_views"
        case title, channel, duration
    }
}
