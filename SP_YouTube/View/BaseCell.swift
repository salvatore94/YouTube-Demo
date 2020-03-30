//
//  BaseCell.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 29/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class BaseCell : UICollectionViewCell {
    
    @objc func setupViews() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
