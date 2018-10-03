//
//  DownloadsController.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 10/3/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class DownloadsController: UITableViewController {
    var episodes:[Episode] = UserDefaults.standard.getDownloadedEpisodes()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    let cellID = "cellID"
    fileprivate func setupTableView()
    {
        tableView.register(EpisodeCell.self, forCellReuseIdentifier:cellID)
    }
    //Mark:-
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    override func viewWillAppear(_ animated: Bool)
    {
        episodes = UserDefaults.standard.getDownloadedEpisodes()
        let rootController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        rootController.viewControllers![2].tabBarItem.badgeValue = nil
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let savedEpisodes = UserDefaults.standard.getDownloadedEpisodes()
        let afterDeleting = savedEpisodes.filter {
            (episode) -> Bool in
            (episode.title != episodes[indexPath.item].title && episode.streamURL != episodes[indexPath.item].streamURL)
        }
        let data = try? JSONEncoder().encode(afterDeleting)
        UserDefaults.standard.set(data,forKey: UserDefaults.downloadedEpisodeKey)
        self.episodes = afterDeleting
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        rootController?.maximizePlayerView(maximize: true)
    }
}
