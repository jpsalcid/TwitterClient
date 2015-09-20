//
//  Tweet.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/14/15.
//  Copyright (c) 2015 Jasen Salcido. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var idString: String?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweeted: Bool?
    var favorited: Bool?
    var retweetStatus: NSDictionary?
    var retweetUser: User?
    // kevin suggestion store the retweet Id since you lose it on refresh
    var retweetStringId: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    
    init(dictionary: NSDictionary){
        id = dictionary["id"] as? Int
        idString = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        
        let createdAtTweetString = dictionary["created_at"] as? String
        
        
        let longFormatter = NSDateFormatter()
        longFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = longFormatter.dateFromString(createdAtTweetString!)
        
        if createdAt != nil {
            let shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "M/d/yy"
            createdAtString = shortFormatter.stringFromDate(createdAt!)
        }
        
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        retweetStatus = dictionary["retweeted_status"] as? NSDictionary
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        
        
        // swap users
        // retweet user is the current user, the original is in the retweet status
        if retweetStatus != nil {
            retweetUser = user
            user = User(dictionary: retweetStatus?["user"] as! NSDictionary)
        }
        
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
