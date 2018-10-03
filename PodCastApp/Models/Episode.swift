//
//  Episode.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
import FeedKit
struct Episode :Codable {
    let title:String?
    let pubDate:Date?
    let description:String?
    var imageURL:String?
    var backUpURL:String = ""
    let author:String?
    let streamURL:String?
    init(feed:RSSFeedItem) {
        title = feed.title
        pubDate = feed.pubDate
        description = feed.iTunes?.iTunesSubtitle ?? feed.description ?? ""
        imageURL = feed.iTunes?.iTunesImage?.attributes?.href
        author = feed.iTunes?.iTunesAuthor ?? feed.author
        streamURL = feed.enclosure?.attributes?.url
    }
}
