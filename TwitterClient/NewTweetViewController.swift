//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Jasen Salcido on 9/15/15.
//  Copyright (c) 2015 Jasen Salcido. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    var originalTweetStringId: String?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetText.becomeFirstResponder()
        nameLabel.text = User.currentUser?.name
        usernameLabel.text = User.currentUser?.screenname
        
        if let urlString = User.currentUser!.profileImageUrl {
            let ownerAvatarURL = NSURL(string: urlString)
            avatarImageView.setImageWithURL(ownerAvatarURL)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        println("testtting")
        if tweetText.text != "" {
            var params: NSDictionary?
            if originalTweetStringId != nil {
                params = ["status": tweetText.text, "in_reply_to_status_id": originalTweetStringId!]
            } else {
                params = ["status": tweetText.text]
            }
            TwitterClient.sharedInstance.update(params, completion: { (tweet, error) -> () in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println(error)
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

}
