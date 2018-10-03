//
//  EpisodeCellClass.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
//reusing podcast Cell
class EpisodeCell: PodcastCell {
    var episode:Episode?{
        didSet{
            if let pubDateDescription = episode?.pubDate
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM, yyyy"
                tracktNameLabel.text = formatter.string(from: pubDateDescription)
            }
            if let title = episode?.title
            {
                artistNameLabel.text = title
                
            }
            
            if let description = episode?.description
            {
                episodeCountLabel.text = description
            }
            
            if let imageURL = episode?.imageURL
            {
                let secureURL = imageURL//.toSecureHTTPS()
                trackImageview.sd_setImage(with: URL(string: secureURL)) { (image, err, cachetype, url) in
                    if err != nil
                    {
                        if let backUpURL = self.episode?.backUpURL
                        {
                            self.trackImageview.sd_setImage(with: URL(string:backUpURL), completed: nil)
                        }
                    }
                }
            }
            else
            {
                if let backUpURL = self.episode?.backUpURL
                {
                    self.trackImageview.sd_setImage(with: URL(string:backUpURL), completed: nil)
                    return
                }
                trackImageview.contentMode = .scaleToFill
                trackImageview.image = #imageLiteral(resourceName: "noimage")
            }
        }
    }
    override func setupViews() {
        super.setupViews()
        
        tracktNameLabel.font = UIFont.systemFont(ofSize: 14)
        tracktNameLabel.textColor = .purple
        //
        artistNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        artistNameLabel.numberOfLines = 2 
        //
        episodeCountLabel.font = UIFont.systemFont(ofSize: 16)
        episodeCountLabel.numberOfLines = 2
        //
        stackView.spacing = 2
    }
}
