//
//  TweetsTableViewCell.swift
//  Twitter Client
//
//  Created by eMobc SL on 15/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {
    var tweetID: String?
    
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetView: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var tweet: Tweet! {
        didSet {
            tweetView.text = tweet.text
            tweetPic.setImageWithURL( (NSURL(string: (tweet.user?.profileImageUrl!)!))! )
            
            nameLabel.text = tweet.user?.name
            let usernameText = "@" + (tweet.user?.screenname)!
            username.text =  (usernameText)
            timeLabel.text = calculateTimestamp(tweet.createdAt!.timeIntervalSinceNow)

            
            tweetID = tweet.id
            retweetCount.text = String(tweet.retweetCount)
            favoriteCount.text = String(tweet.heartCount)
        
            retweetCount.text! == "0" ? (retweetCount.hidden = true) : (retweetCount.hidden = false)
            favoriteCount.text! == "0" ? (favoriteCount.hidden = true) : (favoriteCount.hidden = false)
            
            retweetCount.text! = retweetCount.text!
            favoriteCount.text! = favoriteCount.text!
        }
    }
    
    func calculateTimestamp(tweetTime: NSTimeInterval) -> String {
        //Turn tweetTime into sec, min, hr , days, yrs
        var time = Int(tweetTime)
        var timeAgo = 0
        var timeChar = ""
        
        time = time*(-1)
        
        // Find time ago
        if (time <= 60) { // SECONDS
            timeAgo = time
            timeChar = "sec"
        } else if ((time/60) <= 60) { // MINUTES
            timeAgo = time/60
            timeChar = "min"
        } else if (time/60/60 <= 24) { // HOURS
            timeAgo = time/60/60
            timeChar = "hr"
        } else if (time/60/60/24 <= 365) { // DAYS
            timeAgo = time/60/60/24
            timeChar = "day"
        } else if (time/(3153600) <= 1) { // YEARS
            timeAgo = time/60/60/24/365
            timeChar = "yr"
        }

        return "\(timeAgo)\(timeChar) ago"
    }
    
    @IBAction func retweet(sender: AnyObject) {
        print(tweetID);
        TwitterClient.sharedInstance.retweet(tweetID!, params: nil, completion: { (error)->() in
            
            let data = NSUserDefaults.standardUserDefaults().boolForKey(change)
            if data {
                if self.retweetCount.text! > "0"{
                    self.retweetCount.text = String(self.tweet.retweetCount + 1)
                } else {
                    self.retweetCount.hidden = false
                    self.retweetCount.text = String(self.tweet.retweetCount + 1)
                }
            }
        })
    }
    
    @IBAction func favorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorited(tweetID!, params: nil, completion: {(error) -> () in
            
            if self.favoriteCount.text! > "0" {
                self.favoriteCount.text = String(self.tweet.heartCount + 1)
            } else {
                self.favoriteCount.hidden = false
                self.favoriteCount.text = String(self.tweet.heartCount + 1)
            }
        })
    }
}