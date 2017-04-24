//
//  AccountTableViewCell.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/22/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userScreenName: UILabel!
    @IBOutlet var cellLeadingConstraint: NSLayoutConstraint!
    
    var user: User! {
        didSet {
            if let image = user.profileUrl {
                userProfileImage.setImageWith(image)
            }
            userName.text = user.name
            if let screenName = user.screenName {
                userScreenName.text = "@" + screenName
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

}
