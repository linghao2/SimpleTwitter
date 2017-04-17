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
    
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var userProfileTopConstraint: NSLayoutConstraint!
    
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

            var retweetName: String! = "retweet"
            var retweetColor: UIColor! = UIColor.darkGray
            if tweet.retweeted {
                retweetName = "retweet-green"
                retweetColor = UIColor(red: 53/256, green: 184/256, blue: 69/256, alpha: 1.0)
            }
            retweetButton.imageView?.image = UIImage.init(named: retweetName)
            retweetCount.textColor = retweetColor
            
            var favoriteName: String! = "like"
            var favoriteColor: UIColor! = UIColor.darkGray
            if tweet.favorited {
                favoriteName = "like-red"
                favoriteColor = UIColor(red: 199/256, green: 14/256, blue: 61/256, alpha: 1.0)
            }
            favoriteButton.imageView?.image = UIImage.init(named: favoriteName)
            favoriteCount.textColor = favoriteColor
            
            let hasRetweet = tweet.retweetUser == nil
            retweetedImage.isHidden = hasRetweet
            whoRetweeted.isHidden = hasRetweet
            var constraintsConst = 10
            if hasRetweet {
                constraintsConst = 2
            }
            userProfileTopConstraint.constant = CGFloat(constraintsConst)
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

    @IBAction func onRetweetButton(_ sender: Any) {
        if !tweet.retweeted {
            tweet.retweeted = true
            tweet.retweetCount += 1
            retweetCount.text = String(tweet.retweetCount)
            retweetCount.textColor = UIColor(red: 53/256, green: 184/256, blue: 69/256, alpha: 1.0)
            retweetButton.imageView?.image = UIImage.init(named: "retweet-green")
            retweetButton.setNeedsLayout()
            TwitterClient.sharedInstance?.retweet(id: tweet.id_string)
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if !tweet.favorited {
            tweet.favorited = true
            tweet.favoritesCount += 1
            favoriteCount.text = String(tweet.favoritesCount)
            favoriteCount.textColor = UIColor(red: 199/256, green: 14/256, blue: 61/256, alpha: 1.0)
            favoriteButton.imageView?.image = UIImage.init(named: "like-red")
            retweetButton.setNeedsLayout()
            TwitterClient.sharedInstance?.favorite(id: tweet.id_string)
        }
    }
}
