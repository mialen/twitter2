//
//  Tweet.swift
//  twitter
//
//  Created by Alena Nikitina on 9/27/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var createdDate: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var retweeted: Bool?
    var favorited: Bool?
    var idStr: String?
    var starImg : String?
    var retweetImg : String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        createdDate = formatter.stringFromDate(createdAt!)
        
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        idStr = dictionary["id_str"] as? String
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
        starImg = "star.png"
        retweetImg = "retweet.png"
        
        if(favorited!) {
            starImg = "star-yellow.png"
        }
        
        if(retweeted!) {
            retweetImg = "retweet-grn.png"
        }
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
            
        }
        
        return tweets
    }
   
}
