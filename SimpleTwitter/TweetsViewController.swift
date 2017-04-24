//
//  TweetsViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/13/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetDelegate {

    @IBOutlet var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "BaseTweetTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BaseTweetTableViewCell")

        // automatically resize row
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
        
        // Tap gesture
        
        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onTapGesture(recognizer: UITapGestureRecognizer) {
        print("onTapGesture \(recognizer.view)")
        let indexPath = tableView.indexPathForRow(at: recognizer.location(in: tableView))
        self.performSegue(withIdentifier: "TweetProfileSegue", sender: indexPath)
    }
    
    // MARK: Refresh
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
        
    }
    
    
    // MARK: Navigation
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OneTweetSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! OneTweetViewController
                controller.tweet = tweets?[indexPath.row]
            }            
        } else if segue.identifier == "NewTweetSegue" {
            let navController = segue.destination as! UINavigationController
            let newTweetVC = navController.topViewController as! NewTweetViewController
            newTweetVC.delegate = self
        } else if segue.identifier == "TweetProfileSegue" {
            if let indexPath = sender as? IndexPath {
                let controller = segue.destination as! ProfileViewController
                let tweet = tweets?[indexPath.row]
                controller.user = tweet?.user
            }
        }
    }

    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "BaseTweetTableViewCell", for: indexPath) as! BaseTweetTableViewCell
        tweetCell.selectionStyle = .none
        tweetCell.tweet = tweets?[indexPath.row]
        
        let goGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(recognizer:)))
        tweetCell.userProfileImage.addGestureRecognizer(goGesture)
        
        return tweetCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "OneTweetSegue", sender: tableView)
    }
    
    // MARK: NewTweetDelegate
    
    func newTweet(newTweetViewController: NewTweetViewController, newTweet: Tweet) {
        tweets?.insert(newTweet, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
}
