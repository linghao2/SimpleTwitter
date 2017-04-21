//
//  ProfileViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var user: User!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        let nibName = UINib(nibName: "BaseTweetTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BaseTweetTableViewCell")
        
        // automatically resize row
//        tableView.estimatedRowHeight = 320
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        if user == nil {
            user = User.currentUser
        }
        
        TwitterClient.sharedInstance?.userTimeline(screenName: user.screenName, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return 1 + tweets.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.user = user
            return cell
        } else {
            let tweetCell = tableView.dequeueReusableCell(withIdentifier: "BaseTweetTableViewCell", for: indexPath) as! BaseTweetTableViewCell
            tweetCell.tweet = tweets?[indexPath.row - 1]
            return tweetCell
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
