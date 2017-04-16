//
//  NewTweetViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/14/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

protocol NewTweetDelegate: class {
    func newTweet(newTweetViewController: NewTweetViewController, newTweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userScreenName: UILabel!
    @IBOutlet var tweetTextView: UITextView!
    
    var tweetCount: UILabel!
    
    weak var delegate: NewTweetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.currentUser
        userName.text = user?.name
        userScreenName.text = user?.screenName
        if let image = user?.profileUrl {
            userImage.setImageWith(image)
        }
        
        tweetCount = UILabel()
        // TODO remove hack
        tweetCount.text = "AAAAAAAAAAAAAAAAAA"
        tweetCount.textColor = UIColor.lightGray
        tweetCount.textAlignment = .right
        print("before tweetCount \(tweetCount.bounds)")
        tweetCount.sizeToFit()
        print("tweetCount \(tweetCount.bounds)")

        navigationItem.titleView = tweetCount
        tweetCount.text = "150"
        
        tweetTextView.delegate = self
        
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Text view
    func textViewDidChange(_ textView: UITextView) {
        let count = Int(textView.text.characters.count)
        tweetCount.text = String(150 - count)
    }

    // MARK: Navigation

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        print("Tweet: \(tweetTextView.text)")
        if let tweet = tweetTextView.text {
            TwitterClient.sharedInstance?.tweet(tweet: tweet, success: { (newTweet: Tweet) in
                // delegate new tweet
                self.delegate?.newTweet(newTweetViewController: self, newTweet: newTweet)
            }, failure: { (error: Error) in
                print("create new tweet error: \(error.localizedDescription)")
            })
        }
        
        dismiss(animated: true)
    }
}
