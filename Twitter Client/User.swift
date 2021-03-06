//
//  User.swift
//  Twitter Client
//
//  Created by eMobc SL on 14/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
var count = 0

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class var currentUser: User? {
        get {
            if _currentUser != nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey)
            
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data! as! NSData, options: NSJSONReadingOptions()) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        print("Error parsing JSON")
                    }
                }
            }
        
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch _{
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                }
            }
        }
    }
}