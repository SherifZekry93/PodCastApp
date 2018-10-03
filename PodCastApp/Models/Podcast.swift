//
//  Podcast.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
class Podcast:NSObject, Codable , NSCoding
{
    func encode(with aCoder: NSCoder) {
        print("tryinh to encode")
        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        aCoder.encode(feedUrl ?? "",forKey: "feedURLKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("trying to decode")
        self.trackName =  aDecoder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedURLKey") as? String
    }
    
    var trackName:String?
    var artistName:String?
    var trackCount:Int?
    var artworkUrl600:String?
    var feedUrl:String?
    
}
