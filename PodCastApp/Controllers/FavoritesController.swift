//
//  ViewController.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit

class FavoriteViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var podcasts:[Podcast] = UserDefaults.standard.getSavedCoreDataPodcasts()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        podcasts = UserDefaults.standard.getSavedCoreDataPodcasts()
        collectionView?.reloadData()
        let rootController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        rootController.viewControllers![0].tabBarItem.badgeValue = nil
        
    }
    func setupCollectionView()
    {
        collectionView?.register(FavoriteCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(longGestureRecognizer)
        
    }
    @objc func handleLongPress(gesture:UILongPressGestureRecognizer)
    {
        let location = gesture.location(in: collectionView)
        let indexPath = collectionView?.indexPathForItem(at: location)
        let alertController = UIAlertController(title: "Remove Podcast", message: nil, preferredStyle: .actionSheet)
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) {
            (_) in
            guard let toRemoveIndex = indexPath else {return}
            self.podcasts.remove(at: toRemoveIndex.item)
            self.collectionView?.deleteItems(at: [toRemoveIndex])
            let podCastsToSave = NSKeyedArchiver.archivedData(withRootObject: self.podcasts)
            UserDefaults.standard.setValue(podCastsToSave, forKey: UserDefaults.userDefaultsKey)
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancelled")
        }
        alertController.addAction(deleteAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return podcasts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteCell
        cell.podcast = podcasts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width:width, height: width + 44)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = EpisodesController()
        controller.podcast = podcasts[indexPath.item]
        navigationController?.pushViewController(controller, animated: true)
    }
}
