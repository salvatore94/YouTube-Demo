//
//  UIImage+Extensions.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 31/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

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
