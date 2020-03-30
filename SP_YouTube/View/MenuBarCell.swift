//
//  MenuBarCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 29/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class MenuBarCell : BaseCell {
    private let normalColor = UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
    private let selectedColor = UIColor.white
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        return iv
    }()
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? selectedColor : normalColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet{
            imageView.tintColor = isHighlighted ? selectedColor : normalColor
        }
    }
    
    override func setupViews() {
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    }
    
    
}
