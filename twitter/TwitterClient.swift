//
//  TwitterClient.swift
//  twitter
//
//  Created by Alena Nikitina on 9/27/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

let twitterConsumerKey = "JzSMYf7oglR9vfpEbQazWoREJ"
let twitterConsumerSecret = "qUqrY1534wni5pi5k61jjk5V31zYsx00gSWV5DPCgK6po9j7oL"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
           
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error timeline")
                completion(tweets: nil, error: error)

        })
    }
    
    func postTweet(status: NSDictionary?) {
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: status, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error post")
        })
    }
    
    func postRetweet(id: String!) {
        var url = "https://api.twitter.com/1.1/statuses/retweet/" + id + ".json"
        println(url)
        POST(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error retweet")
        })
    }
    
    func postFavorite(id: NSDictionary?, isFavorite: Bool!) {
        var method = "create"
        if(!isFavorite!){
            method = "destroy"
        }
        var url = "https://api.twitter.com/1.1/favorites/" + method + ".json"
        println(url)
        
        POST(url, parameters: id, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error post")
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token and redirect
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success:{ (requestToken: BDBOAuthToken!) -> Void in
            print("requert token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) { (error: NSError!) -> Void in
                print("error")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            print("access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error")
                    self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
                print("error")
                self.loginCompletion?(user: nil, error: error)
        }
    }
   
}
