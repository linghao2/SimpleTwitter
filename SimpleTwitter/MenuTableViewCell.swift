//
//  MenuTableViewCell.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/20/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var menuLabel: UILabel!
    
    var menuText: String? {
        didSet {
            menuLabel.text = menuText
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
