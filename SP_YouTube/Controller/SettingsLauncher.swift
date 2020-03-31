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
    
    public func showSettings() {
        let optionalWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
        guard let window = optionalWindow else {return}
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        blackView.frame = window.frame
        collectionView.frame = CGRect(x: 0, y: window.frame.maxY, width: window.frame.width, height: collectionViewHeight)
        
        window.addSubview(blackView)
        window.addSubview(collectionView)
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.blackView.alpha = 1
            self.collectionView.frame.origin.y = window.frame.maxY - self.collectionViewHeight
        }.startAnimation()
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SettingsLauncher.handleDismiss)))
    }
    
    @objc
    private func handleDismiss() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.blackView.alpha = 0
        }
        let optionalWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
        if let window = optionalWindow {
            animator.addAnimations {
                self.collectionView.frame.origin.y = window.frame.maxY
            }
        }
        animator.addCompletion { (_) in
            self.blackView.removeFromSuperview()
            self.collectionView.removeFromSuperview()
        }
        animator.startAnimation()
    }
    
    private func fetchSettings() {
        let settingsIcons = ["settings", "privacy", "feedback", "help", "switch_account", "cancel"]
        let settingsTitles = ["Impostazioni", "Privacy e Sicurezza", "Manda un Feedback", "Aiuto", "Cambia Account", "Annulla"]
        
        assert(settingsTitles.count == settingsIcons.count)
        
        for i in 0..<settingsIcons.count {
            let title = settingsTitles[i]
            let iconName = settingsIcons[i]
            let setting = Setting(name: title, imageName: iconName)
            settings.append(setting)
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
