//
//  SearchController.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Alamofire
class PodcastsSearchController: UITableViewController,UISearchBarDelegate {
    
    let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    var dummyPodcasts:[Podcast] = []
    let headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let headerActivityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSerachBar()
        setupTableView()
        navigationController?.navigationBar.isTranslucent = false
    }
    //MARK:- Search Bar Stuff
    fileprivate func setupSerachBar()
    {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""
        {
            self.headerLabel.text = "Nothing to display! Please enter a new search term."
            self.headerActivityIndicator.stopAnimating()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dummyPodcasts = []
        if Connectivity.isConnectedToInternet
        {
            headerActivityIndicator.startAnimating()
            headerLabel.text = "Loading Episodes"
            APIServiceClass.shared.searchForPodcast(searchText: searchBar.text!) { (loadedData,searchResult) in
                if let results = searchResult.results
                {
                    self.dummyPodcasts = results
                    self.tableView.reloadData()
                    self.headerActivityIndicator.stopAnimating()
                }
                if !loadedData
                {
                    self.headerActivityIndicator.stopAnimating()
                    self.headerLabel.text = "Something went wrong. Please try again!"
                }
            }
        }
        else
        {
            print("You are not connected to the internet")
            headerLabel.text = "Please make sure you are connect to the internet!"
        }
    }
    //MARK:- UItableview Stuff setup
    fileprivate func setupTableView()
    {
        tableView.register(PodcastCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let attributedString = NSMutableAttributedString(string: "Nothing to display! Please Enter a new search Term.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        headerLabel.attributedText = attributedString
        headerLabel.numberOfLines = -1
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 18)
        headerLabel.textColor = .blue
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerActivityIndicator)
        NSLayoutConstraint.activate([
            headerActivityIndicator.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerActivityIndicator.bottomAnchor.constraint(equalTo: headerLabel.topAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0)
            ])
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dummyPodcasts.count > 0 ? 0 : 200//view.frame.height
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPodcasts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        let podCast = dummyPodcasts[indexPath.row]
        cell.podcast = podCast
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = EpisodesController()
        controller.podcast = dummyPodcasts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
  
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("hello")
    }*/
}
