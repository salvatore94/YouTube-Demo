//
//  SettingsLauncher.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 31/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import UIKit

class SettingsLauncher : NSObject {
    private let settingsCellID = "settingCellID"
    private let blackView = UIView()

    
    private var settings : [Setting] = []
    
    private let cellHeight : CGFloat = 44
    private var collectionViewHeight : CGFloat {
        get {
            return cellHeight * CGFloat(settings.count)
        }
    }
    
    public weak var homeController: HomeController?
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init() {
        super.init()
        
        fetchSettings()
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: settingsCellID)
    }
    
    private var collectionViewBottomAnchor: NSLayoutConstraint!
    
    public func showSettings() {
        let optionalWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
        guard let window = optionalWindow else {return}
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        //blackView.frame = window.frame
        //collectionView.frame = CGRect(x: 0, y: window.frame.maxY, width: window.frame.width, height: collectionViewHeight)
        
        window.addSubview(blackView)
        window.addSubview(collectionView)
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        blackView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        blackView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        window.layoutIfNeeded()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true

        collectionViewBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: collectionViewHeight)
        collectionViewBottomAnchor.isActive = true
        window.layoutIfNeeded()
        
        collectionViewBottomAnchor.constant = 0
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.blackView.alpha = 1
            window.layoutIfNeeded()
        }.startAnimation()
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SettingsLauncher.handleDismiss)))
    }
    
    @objc
    private func handleDismiss(completion: (()->Void)? = nil) {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.blackView.alpha = 0
        }
        collectionViewBottomAnchor.constant = collectionViewHeight
        let optionalWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
        if let window = optionalWindow {
            animator.addAnimations {
                window.layoutIfNeeded()
            }
        }
        animator.addCompletion { (_) in
            self.blackView.removeFromSuperview()
            self.collectionView.removeFromSuperview()
            completion?()
        }
        animator.startAnimation()
    }
    
    private func fetchSettings() {
        let settingsTypes : [SettingType] = [.settings, .privacy, .feedback, .help, .switchAccount, .cancel]
        
        settingsTypes.forEach { (type) in
            settings.append(Setting(type: type))
        }
        
    }
}


extension SettingsLauncher: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingsCellID, for: indexPath) as! SettingsCell
        
        cell.setting = settings[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = settings[indexPath.item].name
      
        let type = settings[indexPath.item].type
        
        let completion = type == .cancel ? {} : {self.homeController?.showControllerForSettings(withTitle: title)}
        
        handleDismiss(completion: completion)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
