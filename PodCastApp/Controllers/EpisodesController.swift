//
//  EpisodesController.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import FeedKit
class EpisodesController: UITableViewController {
    var podcast:Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    var episodes:[Episode]?
    func fetchEpisodes()
    {
        if let url = podcast?.feedUrl
        {
            APIServiceClass.shared.fetchEpisodes(backUpImageURL:podcast?.artworkUrl600 ?? "",url: url) { (episodes) in
                self.episodes = episodes
                self.tableView.reloadData()
            }
        }
    }
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        setupNavigationFavorite()
    }
    
    fileprivate func setupNavigationFavorite()
    {
        let savedPodcasts = UserDefaults.standard.getSavedCoreDataPodcasts()
        let hasFavorited = savedPodcasts.index {
            $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName
        }

        if hasFavorited != nil
        {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "heart").withRenderingMode(UIImageRenderingMode.alwaysTemplate) , landscapeImagePhone: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .red
        }
        else
        {
            let favoriteButton = UIBarButtonItem(title: "favorite", style: .plain, target: self, action: #selector(handleFavorite))
           // let fetchButton = UIBarButtonItem(title: "fetch", style: .plain, target: self, action: #selector(handleFetch))
            navigationItem.rightBarButtonItems = [favoriteButton]//,fetchButton]
        }
    }
    
    @objc func handleFavorite()
    {
        let userDefaulstPodcasts = UserDefaults.standard.getSavedCoreDataPodcasts()
        guard let podcastToSave = self.podcast else {return}
        var listOfPodcasts = userDefaulstPodcasts
        listOfPodcasts.append(podcastToSave)
        let podcastDataToSave = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.set(podcastDataToSave, forKey: UserDefaults.userDefaultsKey)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "heart").withRenderingMode(UIImageRenderingMode.alwaysTemplate) , landscapeImagePhone: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .red
        showBadgeHighlight()
    }
    fileprivate func showBadgeHighlight()
    {
        let rootController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        rootController.viewControllers![0].tabBarItem.badgeValue = "New"
    }
    //let userDefaultsKey:String = "userDefaultsKey"
    
    @objc func handleFetch()
    {
        let userDefaulstPodcasts = UserDefaults.standard.getSavedCoreDataPodcasts()
        userDefaulstPodcasts.forEach({
            print($0.trackName ?? "")
        })
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = episodes?[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            UserDefaults.standard.downloadEpisode(episode: self.episodes![indexPath.row])
            let rootController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            rootController.viewControllers![2].tabBarItem.badgeValue = "New"
        }
        return [downloadAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let episode = episodes?[indexPath.row]
        {
            let rootController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
            rootController?.playerDetails.episode = episode
            rootController?.maximizePlayerView(maximize: true)
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiview = UIView()
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false 
        activityIndicator.startAnimating()
        let loadingLabel = UILabel()
        loadingLabel.text = "Loading Epsiodes"
        loadingLabel.font = UIFont.systemFont(ofSize: 18)
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        uiview.addSubview(activityIndicator)
        uiview.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: uiview.centerYAnchor),
            loadingLabel.leadingAnchor.constraint(equalTo: uiview.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: uiview.trailingAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor,constant:10),
            ])
        return uiview
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let count = episodes?.count else {return view.frame.height}
        return count > 0 ? 0 : 200//view.frame.height
    }
}
