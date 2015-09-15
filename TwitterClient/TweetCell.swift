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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
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
        usernameLabel.text = tweet.user!.screenname
        
        if let urlString = tweet.user!.profileImageUrl {
            let ownerAvatarURL = NSURL(string: urlString)
            avatarImageView.setImageWithURL(ownerAvatarURL)
        }
        descriptionLabel.text = tweet.text
    }

}
