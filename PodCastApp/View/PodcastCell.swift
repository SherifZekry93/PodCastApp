//
//  PodcastCell.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SDWebImage
class PodcastCell: UITableViewCell {
    var podcast:Podcast?{
        didSet{
            if let trackName = podcast?.trackName
            {
                 tracktNameLabel.text = trackName
            }
            if let artistName = podcast?.artistName
            {
                artistNameLabel.text = artistName
            }
            if let episodeCount = podcast?.trackCount
            {
                episodeCountLabel.text = "\(episodeCount)"
            }
            if let imageURL = podcast?.artworkUrl600
            {
                trackImageview.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
            
        }
    }
    let tracktNameLabel:UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.boldSystemFont(ofSize: 18)
       label.numberOfLines = 2
       label.text = "Track Name.."
       return label
    }()
    
    let artistNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        label.text = "Artist Names"
        return label
    }()
    
    let episodeCountLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Loading..ßß"
        return label
    }()
    
    let trackImageview:UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.sd_setIndicatorStyle(.gray)
        image.sd_setShowActivityIndicatorView(true)
        image.image = #imageLiteral(resourceName: "podCastIcon")
        return image
    }()
    
    lazy var stackView:UIStackView = {
       let uiStackView = UIStackView(arrangedSubviews: [tracktNameLabel,artistNameLabel,episodeCountLabel])
        uiStackView.axis = .vertical
        uiStackView.translatesAutoresizingMaskIntoConstraints = false
        uiStackView.spacing = 4
       return uiStackView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    func setupViews()
    {
        addSubview(trackImageview)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            trackImageview.leadingAnchor.constraint(equalTo: leadingAnchor,constant:8),
            trackImageview.topAnchor.constraint(equalTo: topAnchor,constant:8),
            trackImageview.widthAnchor.constraint(equalToConstant:100),
            trackImageview.heightAnchor.constraint(equalToConstant: 100),
            stackView.leadingAnchor.constraint(equalTo: trackImageview.trailingAnchor,constant:8),
            stackView.centerYAnchor.constraint(equalTo: trackImageview.centerYAnchor,constant:0),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant:-5),
            tracktNameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
