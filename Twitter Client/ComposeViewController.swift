//
//  ComposeViewController.swift
//  Twitter Client
//
//  Created by eMobc SL on 28/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    let MAX_CHARACTERS_ALLOWED = 140
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
                super.viewDidLoad()
        
        //self.profileImage.setImageWithURL(User.currentUser?.profileImageUrl)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.nameLabel.text = User.currentUser?.name
        self.screennameLabel.text = "@\(User.currentUser!.screenname)"
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let userInfo = notification.userInfo!
            //let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            //self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let userInfo = notification.userInfo!
            //let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            //self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        
        //self.remainingCharactersLabel.text = "\(MAX_CHARACTERS_ALLOWED)"
        
        self.textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustScrollViewContentSize()
    }
    
    func textViewDidChange(textView: UITextView) {
        let status = textView.text
        //let charactersRemaining = MAX_CHARACTERS_ALLOWED - countElements(status)
        //self.remainingCharactersLabel.text = "\(charactersRemaining)"
        //self.remainingCharactersLabel.textColor = charactersRemaining >= 0 ? .lightGrayColor() : .redColor()
        self.adjustScrollViewContentSize()
    }
    
    func adjustScrollViewContentSize() {
        //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.textView.frame.origin.y + self.textView.frame.size.height)
    }
    
    @IBAction func onTweetTap(sender: AnyObject) {
        let status = self.textView.text
        //if (countElements(status) == 0) {
        //    return
        //}
        
        var params: NSDictionary = [
            "status": status
        ]
        
        TwitterClient.sharedInstance.postStatusUpdateWithParams(params, completion: { (status, error) -> () in
            if error != nil {
                NSLog("error posting status: \(error)")
                return
            }
            //NSNotificationCenter.defaultCenter().postNotificationName(TwitterEvents.StatusPosted, object: status)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func onCancelTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onScrollViewTap(sender: AnyObject) {
        self.textView.becomeFirstResponder()
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
