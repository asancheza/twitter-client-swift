//
//  TwitterClient.swift
//  Twitter Client
//
//  Created by eMobc SL on 08/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import BDBOAuth1Manager

let twitterConsumerKey = ""
let twitterConsumerSecret = ""
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

}
