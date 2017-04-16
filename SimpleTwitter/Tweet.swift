//
//  Tweet.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/13/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id_string: String!
    var text: String?
    var createdAt: Date?
    var retweetCount: Int = 0
    var retweeted: Bool = false
    var favoritesCount: Int = 0
    var favorited: Bool = false
    var retweetUser: User?
    var user: User?
    
    init(dictionary: Dictionary<String, Any?>) {
        id_string = dictionary["id_str"] as! String?
        text = dictionary["text"] as! String?
        if let dateString = dictionary["created_at"] as! String? {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
            createdAt = formatter.date(from: dateString)
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = (dictionary["favorited"] as? Bool) ?? false
        
        if let retweetStatus = dictionary["retweeted_status"] as? Dictionary<String, Any?> {
            print(retweetStatus)
            let retweetUserDictionary = retweetStatus["user"] as? Dictionary<String, Any?>
            if let retweetUserDictionary = retweetUserDictionary {
                user = User(dictionary: retweetUserDictionary)
            }
            let userDictionary = dictionary["user"] as? Dictionary<String, Any?>
            if let userDictionary = userDictionary {
                retweetUser = User(dictionary: userDictionary)
            }
        } else {
            let userDictionary = dictionary["user"] as? Dictionary<String, Any?>
            if let userDictionary = userDictionary {
                user = User(dictionary: userDictionary)
            }
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [Dictionary<String, Any?>]) -> [Tweet] {
        var tweets = [Tweet]()
        for one in dictionaries {
            let tweet = Tweet(dictionary: one)
            tweets.append(tweet)
        }
        return tweets
    }
}
