//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/14/15.
//  Copyright (c) 2015 Jasen Salcido. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContentWithTweet(tweet: Tweet) {
        nameLabel.text = tweet.user!.name
//        usernameLabel.text = tweet.user!.screenname
        descriptionLabel.text = tweet.text
        timestampLabel.text = tweet.createdAtString
        
        if let urlString = tweet.user!.profileImageUrl {
            let ownerAvatarURL = NSURL(string: urlString)
            avatarImageView.setImageWithURL(ownerAvatarURL)
        }

        if tweet.retweeted != true {
            retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
        } else if tweet.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
        
        if tweet.favorited != true {
            favoriteButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
        } else if tweet.favorited == true {
            favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
    
    }

}
