//
//  TweetTableViewCell.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/13/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet var retweetedImage: UIImageView!
    @IBOutlet var whoRetweeted: UILabel!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userScreenName: UILabel!
    @IBOutlet var createdAt: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var retweetCount: UILabel!
    @IBOutlet var favoriteCount: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            userName.text = tweet.user?.name
            if let screenName = tweet.user?.screenName {
                userScreenName.text = "@" + screenName
            }
            if let elapsed = tweet.createdAt?.timeIntervalSinceNow {
                createdAt.text = calcElapsedText(seconds: -elapsed)
            }
            
            if let image = tweet.user?.profileUrl {
                userProfileImage.setImageWith(image)
            }
            
            retweetCount.text = String(tweet.retweetCount)
            favoriteCount.text = String(tweet.favoritesCount)

            let hasRetweet = tweet.retweetUser == nil
            retweetedImage.isHidden = hasRetweet
            whoRetweeted.isHidden = hasRetweet
            if tweet.retweetUser != nil {
                if let retweetUserName = tweet.retweetUser!.name {
                    whoRetweeted.text = retweetUserName + " retweeted"
                }
            }
        }
    }
    
    func calcElapsedText(seconds: Double) -> String {
        if seconds < 60 {
            return String(Int(seconds)) + "s"
        }
        let minutes = seconds / 60.0
        if minutes < 60 {
            return String(Int(minutes)) + "m"
        }
        let hours = minutes / 60.0
        if hours < 24 {
            return String(Int(hours)) + "h"
        }
        let days = hours / 24
        return String(Int(days)) + "d"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
