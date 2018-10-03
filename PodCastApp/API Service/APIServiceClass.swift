//
//  APIServiceClass.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/28/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit
class APIServiceClass{
    static let shared = APIServiceClass()
    
    func searchForPodcast(searchText:String,completionHandler:@escaping (Bool,SearchResult) -> ())
    {
        
        var success:Bool = false
        let url = "https://itunes.apple.com/search"//?term=\(searchText)"
        let params = ["term":searchText,"media":"podcast"]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { (response) in
            
            print(response)
            if response.error != nil
            {
                print("there was an erro")
            }
            if  let data = response.data
            {
                var searchResults:SearchResult?
                do
                {
                    searchResults = try JSONDecoder().decode(SearchResult.self, from: data)
                    success = true
                }
                catch
                {
                    searchResults = SearchResult()
                    success = false
                }
                if let searchResults = searchResults
                {
                    completionHandler(success,searchResults)
                }
            }
        }
    }
    struct SearchResult:Codable{
        var resultCount:Int?
        var results:[Podcast]?
    }
    func fetchEpisodes(backUpImageURL:String,url:String,completitionHandler:@escaping ([Episode]) -> ())
    {
        let secureFeedURL = url
        if let feedURL = URL(string: secureFeedURL)
        {
            DispatchQueue.global(qos: .background).async {
                let parser = FeedParser(URL: feedURL)
                parser.parseAsync { (result) in
                    if result.error != nil
                    {
                        print("parsing feed error",result.error!)
                        return
                    }
                    guard let feed = result.rssFeed else {return}
                    let currenEpisodes = feed.toEpisode(backUpImageURL: backUpImageURL)
                    DispatchQueue.main.async
                        {
                            completitionHandler(currenEpisodes)
                    }
                }
            }
        }
    }
}
