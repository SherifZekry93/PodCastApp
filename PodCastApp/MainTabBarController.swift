//
//  MainTabBarController.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class MainTabBarController:UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        setupViewControllers()
        setupPLayerDetailsView()
        //maximizePlayerView(maximize: false)
    }
    @objc func maximizePlayerView(maximize:Bool)
    {
        playerDetails.isHidden = false
        maximizeLayoutConstraint.constant = maximize ? -view.frame.height : -height-64
        if !maximize
        {
            self.tabBar.transform = .identity
        }
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {

            self.view.layoutIfNeeded()
            if maximize
            {
                self.tabBar.transform = CGAffineTransform(scaleX: 0, y: 100)
                self.playerDetails.miniPlayerView.alpha = 0
                self.playerDetails.containerStackView.alpha = 1
            }
            else
            {
                self.playerDetails.miniPlayerView.alpha = 1
                self.playerDetails.containerStackView.alpha = 0
            }

        }, completion: nil)
    }
    func setupViewControllers()
    {
        let layout = UICollectionViewFlowLayout()
        let favouritesNavController = generateNavigationController(rootController: FavoriteViewController(collectionViewLayout: layout), title: "Favorites", image: #imageLiteral(resourceName: "favoritesIcon"))
        let searchNavController = generateNavigationController(rootController: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "searchIcon"))
        let downloadsNavController = generateNavigationController(rootController: DownloadsController(), title: "Downloads", image: #imageLiteral(resourceName: "downloadsIcon"))
        viewControllers = [
            favouritesNavController,
            searchNavController,
            downloadsNavController
        ]
    }
    //MARK:- Helper Function
    fileprivate func generateNavigationController(rootController:UIViewController,title:String,image:UIImage) -> UIViewController
    {
        let navController = UINavigationController(rootViewController: rootController)
        rootController.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    var maximizeLayoutConstraint:NSLayoutConstraint!
    let playerDetails = PlayerDetailsView()
    var height : CGFloat!
    func setupPLayerDetailsView()
    {
        playerDetails.isHidden = true
        playerDetails.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(playerDetails, belowSubview: tabBar)
        guard let window = UIApplication.shared.keyWindow else {return}
        height = tabBar.frame.height + window.safeAreaInsets.bottom
        maximizeLayoutConstraint = playerDetails.topAnchor.constraint(equalTo: view.bottomAnchor,constant:-height-64)
        NSLayoutConstraint.activate([
            maximizeLayoutConstraint,
            playerDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
}
