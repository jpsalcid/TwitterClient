//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/19/15.
//  Copyright © 2015 Jasen Salcido. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let profileUrlString = User.currentUser!.profileImageUrl {
            let ownerAvatarURL = NSURL(string: profileUrlString)
            profileImageView.setImageWithURL(ownerAvatarURL)
        }

        if let backgroundProfileUrlString = User.currentUser!.backgroundProfileImageUrl {
            let ownerAvatarURL = NSURL(string: backgroundProfileUrlString)
            backgroundImageView.setImageWithURL(ownerAvatarURL)
        }
        
        nameLabel.text = User.currentUser!.name
        let tweetCountString = (User.currentUser!.dictionary["statuses_count"] as! NSNumber).stringValue;
        let followersCountString = (User.currentUser!.dictionary["followers_count"] as! NSNumber).stringValue;
        let followingCountString = (User.currentUser!.dictionary["following"] as! NSNumber).stringValue;
        tweetCount.text = tweetCountString
        followerCount.text = followersCountString
        followingCount.text = followingCountString

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
