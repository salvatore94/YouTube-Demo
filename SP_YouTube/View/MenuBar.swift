//
//  MenuBar.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 29/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class MenuBar : UIView {
    private let cellID = "MenuBarCellID"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = barRedColor
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let imagesName = ["home", "trending", "subscriptions", "account"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .init())
        setupBottomBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var bottomBarLeadingConstraint: NSLayoutConstraint!
    
    func setupBottomBar() {
        let count = CGFloat(imagesName.count)
        let bottomBarView = UIView()
        bottomBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        addSubview(bottomBarView)
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        bottomBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/count).isActive = true
        
        bottomBarLeadingConstraint = bottomBarView.leadingAnchor.constraint(equalTo: leadingAnchor)
        bottomBarLeadingConstraint.isActive = true
    }
}


extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuBarCell
        let cellImageName = imagesName[indexPath.item]
        cell.imageView.image = UIImage(named: cellImageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellWidth = frame.width / CGFloat(imagesName.count)
        let constraintConstant = CGFloat(indexPath.item) * cellWidth
        
        
        bottomBarLeadingConstraint.constant = constraintConstant
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.layoutIfNeeded()
        }.startAnimation()
    }
}
