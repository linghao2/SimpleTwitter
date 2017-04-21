//
//  OneTweetViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/14/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class OneTweetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // automatically resize row
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OneTweetCell", for: indexPath) as! OneTweetTableViewCell
            
            cell.selectionStyle = .none
            cell.tweet = tweet
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "OneEmptyCell")!
        }
    }
    
}
