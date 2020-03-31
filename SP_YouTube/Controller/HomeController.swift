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
    
    private let settingsLauncher = SettingsLauncher()
    
    private let menuBarHeight: CGFloat = 50
    let menuBar : MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    var videos : [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchVideos()
        
        navigationController?.navigationBar.isTranslucent = false
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width-32, height: view.frame.height))
        titleView.text = "HOME"
        titleView.textColor = UIColor.white
        titleView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        navigationItem.titleView = titleView
        
        
        collectionView.backgroundColor = .white
        //Using insets to align the content's of collection view with the menu bar
        collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        setupMenuBar()
        setupNavBarButtons()
        
    }
    
    private func fetchVideos() {
        let urlString = "https://raw.githubusercontent.com/salvatore94/SP_YouTube_assets/master/home.json"
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
                
                DispatchQueue.main.async {
                    self.videos = fetchedVideos
                    self.collectionView.reloadData()
                }

            } catch {
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }

    private func setupNavBarButtons() {
        let moreImage = UIImage(named: "nav_more_icon")
        let searchImage = UIImage(named: "search_icon")
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(HomeController.handleMore))
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(HomeController.handleSearch))
        moreBarButtonItem.tintColor = .white
        searchBarButtonItem.tintColor = .white
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc
    func handleSearch() {
        
    }
    
    @objc
    func handleMore() {
        settingsLauncher.showSettings()
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}

extension HomeController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //We calculate cell's height based on preview size
        //To keep correct aspect ratio for preview we need to give 9/16 of it's width
        //Of course the accessory view height needs to be added
        
        //Padding: top=16, bottom=44+8+16, left=right=16
        let previewHeight : CGFloat = (view.frame.width - 32) * 9/16
        let height : CGFloat = previewHeight + 92
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
}
