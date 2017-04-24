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
    
    var blurImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        let nibName = UINib(nibName: "BaseTweetTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BaseTweetTableViewCell")
        
        // automatically resize row
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if user == nil {
            user = User.currentUser
        }
        print("user name: \(user?.name)")
        title = user?.name
        
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
            cell.selectionStyle = .none
            cell.user = user
            return cell
        } else {
            let tweetCell = tableView.dequeueReusableCell(withIdentifier: "BaseTweetTableViewCell", for: indexPath) as! BaseTweetTableViewCell
            tweetCell.selectionStyle = .none
            tweetCell.tweet = tweets?[indexPath.row - 1]
            return tweetCell
        }
    }
    
    @IBAction func longPressGestureTableView(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView))
            if indexPath?.row == 0 {
                var nextResponder: UIResponder? = self
                repeat {
                    nextResponder = nextResponder?.next
                    if nextResponder is HamburgerViewController {
                        let hamburgerVC = nextResponder as! HamburgerViewController
                        hamburgerVC.selectMenu(named: "Accounts")
                        nextResponder = nil
                    }
                } while nextResponder != nil
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("contentOffset: \(scrollView.contentOffset)")
//        print("contentSize: \(scrollView.contentSize)")
        let contentOffset = scrollView.contentOffset.y
        if contentOffset > -60 && contentOffset < 0 {
            if blurImage == false {
                blurImage = true
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
                cell.profileBackgroundImage?.alpha = 0.5
            }
        }
        if contentOffset > 7 && contentOffset < 23 {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
            cell.imageWidth.constant = 64.0 - contentOffset + 8
            cell.imageHeight.constant = 72.0 - contentOffset + 8
            print("\(cell.imageWidth.constant), \(cell.imageHeight.constant)")
        }
        if contentOffset < -60 {
            if blurImage == true {
                blurImage = false
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
                cell.profileBackgroundImage?.alpha = 1.0
                cell.imageWidth.constant = 64.0
                cell.imageHeight.constant = 72.0
            }
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
