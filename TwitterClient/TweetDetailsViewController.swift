//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/15/15.
//  Copyright (c) 2015 Jasen Salcido. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    var tweet: Tweet?

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = tweet!.user!.name
        usernameLabel.text = tweet!.user!.screenname
        descriptionLabel.text = tweet!.text
//        timestampLabel.text = tweet!.createdAtString
        
        if let urlString = tweet!.user!.profileImageUrl {
            let ownerAvatarURL = NSURL(string: urlString)
            avatarImageView.setImageWithURL(ownerAvatarURL)
        }
        
        if tweet!.retweeted != true {
            retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
        } else if tweet!.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
        
        if tweet!.favorited != true {
            favoriteButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
        } else if tweet!.favorited == true {
            favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
        
        retweetCountLabel.text = "\(tweet!.retweetCount!)"
        favoriteCountLabel.text = "\(tweet!.favoriteCount!)"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        let retweetButton = sender as! UIButton
        let retweet = tweet!
        var params = ["id" : retweet.idString!]
        
        // retweet
        if retweet.retweeted != true {
            TwitterClient.sharedInstance.statusesRetweets(params, completion: { (tweet, error) -> () in
                if error == nil {
                    retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
                    retweet.retweeted = true
                    retweet.retweetStringId = tweet?.idString
                } else {
                    print(error)
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
                        print(error)
                    }
                })
            }
        }
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let favoriteButton = sender as! UIButton
        let favoriteTweet = tweet!
        let params = ["id" : favoriteTweet.idString!]
        
        if favoriteTweet.favorited == true {
            TwitterClient.sharedInstance.favoritesDestroy(params, completion: { (tweet, error) -> () in
                if error == nil {
                    favoriteButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
                    favoriteTweet.favorited = false
                } else {
                    print(error)
                }
            })
        } else {
            TwitterClient.sharedInstance.favoritesCreate(params, completion: { (tweet, error) -> () in
                if error == nil {
                    favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
                    favoriteTweet.favorited = true
                } else {
                    print(error)
                }
            })
        }
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
        let navigationController = segue.destinationViewController as! UINavigationController
        let newTweetViewController = navigationController.topViewController as! NewTweetViewController
        newTweetViewController.originalTweetStringId = tweet?.idString
    }
    
    

}
