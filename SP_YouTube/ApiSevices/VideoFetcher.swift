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
    
    func fetch(type: FetchType, completion: @escaping ([Video])->() ) {
        let urlString = type.urlString
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


enum FetchType : String {
    case home = "home.json"
    case trending = "trending.json"
    case subscription = "subscriptions.json"
    
    private var baseURL : String {get {return "https://raw.githubusercontent.com/salvatore94/SP_YouTube_assets/master/"} }
    public var urlString : String {
        get {
            return baseURL + rawValue
        }
    }
}
