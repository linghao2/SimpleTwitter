//
//  User.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/13/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var profileBackgroundUrl: URL?
    var tagline: String?
    var followersCount: Int = 0
    var followingCount: Int = 0
    
    var dictionary: Dictionary<String, Any?>?
    
    init(dictionary: Dictionary<String, Any?>) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let urlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: urlString)
        }
        if let urlBackgroundString = dictionary["profile_background_image_url_https"] as? String {
            profileBackgroundUrl = URL(string: urlBackgroundString)
        }
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0

        tagline = dictionary["description"] as? String
    }
    
    // MARK: class vars
    
    static let userDidLogout = NSNotification.Name(rawValue: "userDidLogout")
    
    private static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! Dictionary<String, Any?>
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
