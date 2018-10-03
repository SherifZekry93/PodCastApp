//
//  CoreDataPodcast.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 10/2/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
extension UserDefaults
{
    static let userDefaultsKey:String = "userDefaultsKey"
    static let downloadedEpisodeKey:String = "downloadEpisodeKey"
    func getSavedCoreDataPodcasts() -> [Podcast]
    {
        
        if let data = UserDefaults.standard.data(forKey: UserDefaults.userDefaultsKey)
        {
            if let userDefaulstPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
            {
                return userDefaulstPodcasts
            }
        }
        return [Podcast]()
    }
    func downloadEpisode(episode:Episode) {
        var downloadedEpisodes = getDownloadedEpisodes()
        do
        {
            downloadedEpisodes.append(episode)
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data,forKey: UserDefaults.downloadedEpisodeKey)
        }
        catch let error
        {
            print("failed to encode episode",error)
        }
    }
    
    func getDownloadedEpisodes() -> [Episode]
    {
       if  let episodeData = data(forKey: UserDefaults.downloadedEpisodeKey)
       {
        let downloadedEpisodes = try? JSONDecoder().decode([Episode].self, from: episodeData)
                    return downloadedEpisodes!
       }
        return [Episode]()
    }
    
}
