//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/14/15.
//  Copyright (c) 2015 Jasen Salcido. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
//        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogOut(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let favoriteButton = sender as! UIButton
        var favoriteTweet = tweets![favoriteButton.tag] as Tweet
        var params = ["id" : favoriteTweet.idString!]
        
        if favoriteTweet.favorited == true {
            TwitterClient.sharedInstance.favoritesDestroy(params, completion: { (tweet, error) -> () in
                if error == nil {
                    favoriteButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
                    favoriteTweet.favorited = false
                } else {
                    println(error)
                }
            })
        } else {
            TwitterClient.sharedInstance.favoritesCreate(params, completion: { (tweet, error) -> () in
                if error == nil {
                    favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
                    favoriteTweet.favorited = true
                } else {
                    println(error)
                }
            })
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        var retweetButton = sender as! UIButton
        var retweet = tweets![retweetButton.tag] as Tweet
        var params = ["id" : retweet.idString!]
        
        // retweet
        if retweet.retweeted != true {
            TwitterClient.sharedInstance.statusesRetweets(params, completion: { (tweet, error) -> () in
                if error == nil {
                    retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
                    retweet.retweeted = true
                    retweet.retweetStringId = tweet?.idString
                } else {
                    println(error)
                }
            })
        // destroy
        } else if retweet.retweeted == true {
            // only do this if we have the retweetId, otherwise we would have to fetch this...
            if retweet.retweetStringId != nil {
                params["id"] = retweet.retweetStringId
                TwitterClient.sharedInstance.statusesDestroy(params, completion: { (tweet, error) -> () in
                    if error == nil {
                        retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
                        retweet.retweeted = false
                        retweet.retweetStringId = nil
                    } else {
                        println(error)
                    }
                })
            }
        }
    }
    
    func onRefresh() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if error == nil {
                self.refreshControl.endRefreshing()
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                println(error)
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.setContentWithTweet(tweets![indexPath.row])
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            let tweet = tweets![indexPath.row]
            let tweetDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetDetailsViewController.tweet = tweet
        } else if segue.identifier == "replySegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            let replyButton = sender as! UIButton
            let tweet = tweets![replyButton.tag]
            newTweetViewController.originalTweetStringId = tweet.idString
        }
    }

}
