//
//  Channel.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 30/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class Channel: NSObject, Decodable {
    let name : String
    let profileImageName: String
    
    enum CodingKeys: String, CodingKey {
        case profileImageName = "profile_image_name"
        case name
    }
}
