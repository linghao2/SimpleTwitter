//
//  ProfileTableViewCell.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/20/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var profileBackgroundImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followerCount: UILabel!
    
    @IBOutlet var imageHeight: NSLayoutConstraint!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    
    var user: User! {
        didSet {
            if let image = user.profileBackgroundUrl {
                profileBackgroundImage.setImageWith(image)
            }
            if let image = user.profileUrl {
                profileImage.setImageWith(image)
            }
            nameLabel.text = user.name
            if let screenName = user.screenName {
                screenNameLabel.text = "@" + screenName
            }
            followingCount.text = String(user.followingCount)
            followerCount.text = String(user.followersCount)
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

}
