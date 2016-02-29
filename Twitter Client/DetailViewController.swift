//
//  DetailViewController.swift
//  Twitter Client
//
//  Created by eMobc SL on 23/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var tweet: Tweet?
    
    @IBOutlet weak var userTweet: UILabel!
    @IBOutlet weak var retweetsTweet: UILabel!
    @IBOutlet weak var favoritesTweets: UILabel!
    @IBOutlet weak var imageTweet: UIImageView!

    @IBOutlet weak var screenTweet: UILabel!
    @IBOutlet weak var dateTweet: UILabel!
    @IBOutlet weak var textTweet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tweet!.text)
        userTweet.text = tweet!.user?.name
        screenTweet.text = tweet!.user?.screenname
        dateTweet.text = tweet!.createdAtString
        retweetsTweet.text = String(tweet!.retweetCount)
        favoritesTweets.text = String(tweet!.heartCount)
        
        textTweet.text = tweet!.text
        imageTweet.setImageWithURL( (NSURL(string: (tweet!.user?.profileImageUrl!)!))!)
        
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
