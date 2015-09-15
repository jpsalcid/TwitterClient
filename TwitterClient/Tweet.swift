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
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var elapsedTime: Int?
    
    init(dictionary: NSDictionary){
        id = dictionary["id"] as? Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        
        let createdAtTweetString = dictionary["created_at"] as? String
        
        
        var longFormatter = NSDateFormatter()
        longFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = longFormatter.dateFromString(createdAtTweetString!)
        
        if createdAt != nil {
            var shortFormatter = NSDateFormatter()
            shortFormatter.dateFormat = "M/d/yy"
            createdAtString = shortFormatter.stringFromDate(createdAt!)
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
