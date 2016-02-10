//
//  TwitterClient.swift
//  Twitter Client
//
//  Created by eMobc SL on 08/02/16.
//  Copyright © 2016 Neurowork. All rights reserved.
//

import BDBOAuth1Manager

let twitterConsumerKey = "dW1rK57JAhSBVHw8jR8LNLESv"
let twitterConsumerSecret = "56zJQTG1vmLyW8ilNdnqR3QGG6ndZGz07C01j7KGKnj32wF1EY"
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
