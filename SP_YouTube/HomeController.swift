//
//  ViewController.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 27/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {
    private let reuseIdentifier = "HomeControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.isTranslucent = false
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width-32, height: view.frame.height))
        titleView.text = "HOME"
        titleView.textColor = UIColor.white
        titleView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        navigationItem.titleView = titleView
        
        
        let menuBarHeight: CGFloat = 50
        let menuBar = MenuBar()
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        collectionView.backgroundColor = .white
        //Using insets to align the content's of collection view with the menu bar
        collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }


}

extension HomeController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //We calculate cell's height based on preview size
        //To keep correct aspect ratio for preview we need to give 9/16 of it's width
        //Of course the accessory view height needs to be added
        
        //Padding: top=16, bottom=44+8+16, left=right=16
        let previewHeight : CGFloat = (view.frame.width - 32) * 9/16
        let height : CGFloat = previewHeight + 68
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
}
