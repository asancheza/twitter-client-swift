//
//  TweetsViewController.swift
//  Twitter Client
//
//  Created by eMobc SL on 15/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
    @IBAction func onCompose(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //set our nav title to user's screen name
        self.navigationItem.title = User.currentUser?.screenname
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) ->() in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
        controller.tweet = self.tweets![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion:  { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }
}