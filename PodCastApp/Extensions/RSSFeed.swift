//
//  RSSFeed.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
import FeedKit
extension RSSFeed
{
    func toEpisode(backUpImageURL:String) -> [Episode]
    {
        let imageURL = iTunes?.iTunesImage?.attributes?.href
        var currenEpisodes = [Episode]()
        items?.forEach({ (feedItem) in
            var episode = Episode(feed: feedItem)
            if episode.imageURL == nil
            {
                episode.imageURL = imageURL
            }
            episode.backUpURL = backUpImageURL
            currenEpisodes.append(episode)
        })
        return currenEpisodes
    }
}
