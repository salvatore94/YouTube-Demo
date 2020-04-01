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
    private let reuseIdentifierTrending = "HomeControllerCellTrending"
    private let reuseIdentifierSubscription = "HomeControllerCellSubscription"
    
    private lazy var settingsLauncher : SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    private let menuBarHeight: CGFloat = 50
    lazy var menuBar : MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    lazy var titleView : UILabel = {
        let tv = UILabel()
        tv.textColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tv.frame = CGRect(x: 0, y: 0, width: view.frame.width-32, height: view.frame.height)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        
        titleView.text = "  \(titles.first!)"
        navigationItem.titleView = titleView
        
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
        settingsLauncher.collectionView.collectionViewLayout.invalidateLayout()
        menuBar.collectionView.collectionViewLayout.invalidateLayout()
        
        collectionView.visibleCells.forEach { (cell) in
            if let cell = cell as? FeedCell {
                cell.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    public func showControllerForSettings(withTitle title: String) {
        let dummyViewController = UIViewController()
        navigationController?.pushViewController(dummyViewController, animated: true)
        dummyViewController.view.backgroundColor = .white
        dummyViewController.navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    public func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .init(), animated: true)
        
        setTitle(for: menuIndex)
    }

}

extension HomeController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var identifier = reuseIdentifier
        if indexPath.item == 1 {
            identifier = reuseIdentifierTrending
        } else if indexPath.item == 2 {
            identifier = reuseIdentifierSubscription
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FeedCell
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //We need to remove top insets from height to prevent compiler warning
        let height = view.frame.height - menuBarHeight
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.bottomBarLeadingConstraint.constant = scrollView.contentOffset.x/4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetX = targetContentOffset.pointee.x
        let index : Int = Int(targetX/view.frame.width)
      
        setTitle(for: index)
        
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
    }
}


//MARK: Utils
private extension HomeController {
    private func setTitle(for index: Int) {
        let currentTitle = titles[index]
        titleView.text = "  \(currentTitle)"
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
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        //Using insets to align the content's of collection view with the menu bar
        collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: reuseIdentifierTrending)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: reuseIdentifierSubscription)
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isPagingEnabled = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    @objc
    func handleSearch() {
        scrollToMenuIndex(2)
    }
    
    @objc
    func handleMore() {
        settingsLauncher.showSettings()
    }
    
    
    
    private func setupMenuBar() {
        //we make a dummy redView to hide a glitch that occurs when navBar hides
        let redView = UIView()
        redView.backgroundColor = barRedColor
        view.addSubview(redView)
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        redView.topAnchor.constraint(equalTo:  view.topAnchor).isActive = true
        redView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        redView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        menuBar.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
