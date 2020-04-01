//
//  VideoFetcher.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 01/04/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import Foundation

class VideoFetcher: NSObject {
    
    static let shared = VideoFetcher()
    
    private let urlString = "https://raw.githubusercontent.com/salvatore94/SP_YouTube_assets/master/home.json"
    
    func fetch(completion: @escaping ([Video])->() ) {
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                print("data == nil")
                return
            }
            
            do {
                let fetchedVideos = try JSONDecoder().decode([Video].self, from: data)
                
                completion(fetchedVideos)

            } catch {
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }
}
