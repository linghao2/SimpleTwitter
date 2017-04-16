//
//  OneTweetTableViewCell.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/14/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class OneTweetTableViewCell: UITableViewCell {
    
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
            if let createdDate = tweet.createdAt {
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d/yy, hh:mm a"
                createdAt.text = formatter.string(from: createdDate)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(id: tweet.id_string)
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(id: tweet.id_string)
    }
}
