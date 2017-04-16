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
        
        // automatically resize row
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        }
    }

    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        
        cell.selectionStyle = .none
        cell.tweet = tweets?[indexPath.row]
        
        return cell
    }
    
    // MARK: NewTweetDelegate
    
    func newTweet(newTweetViewController: NewTweetViewController, newTweet: Tweet) {
        tweets?.insert(newTweet, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
}
