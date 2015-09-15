//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/14/15.
//  Copyright (c) 2015 Jasen Salcido. All rights reserved.
//

import UIKit

let twitterConsumerKey = "enjNssr4hzug4CiXkVRx8zHl8"
let twitterConsumerSecret = "PHcdcjYTkr8gZdRhaiEANI4ELc7qWjxZKlzgZm6nOrYzEtSoUy"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletition: ((user: User?, error: NSError?) -> () )?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        // fetch timeline
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting tweets")
            completion(tweets: nil, error: error)
        }
    }
   
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletition = completion
        
        // Fetch reqeust token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            println(requestToken.token)
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            println("error getting token")
            self.loginCompletition?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            println("got access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // fetch user
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("user: \(user.name)")
                self.loginCompletition?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get user")
                self.loginCompletition?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
            println("error getting access token")
            self.loginCompletition?(user: nil, error: error)
        }
        
    }
}
