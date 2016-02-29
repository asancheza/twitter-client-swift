//
//  TwitterClient.swift
//  Twitter Client
//
//  Created by eMobc SL on 08/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "dW1rK57JAhSBVHw8jR8LNLESv"
let twitterConsumerSecret = "56zJQTG1vmLyW8ilNdnqR3QGG6ndZGz07C01j7KGKnj32wF1EY"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

let change = "true"

class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error:NSError?) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func postStatusUpdateWithParams(params: NSDictionary?, completion: (tweet: [Tweet]?, error:NSError?) -> ()){
        GET("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting home timeline")
                completion(tweet: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "getautogrow://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed request")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Get the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters:nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("User: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print(user.name)
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Error verify credentials")
            })
            
            TwitterClient.sharedInstance.GET(
                "1.1/statuses/home_timeline.json",
                parameters: nil,
                success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                    var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                },
                failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func retweet(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet with id: \(id)")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: change)
            NSUserDefaults.standardUserDefaults().synchronize()
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't retweet")
                print(error)
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: change)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                completion(error: error)
        })
    }
    
    func favorited(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Liked tweet with id: \(id)")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: change)
            NSUserDefaults.standardUserDefaults().synchronize()
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't like tweet")
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: change)
                NSUserDefaults.standardUserDefaults().synchronize()
                completion(error: error)
        })
    }
}