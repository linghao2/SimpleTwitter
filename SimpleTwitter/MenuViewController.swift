//
//  MenuViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var profileNavigationController: UIViewController!
    var timelineNavigationController: UIViewController!
    var mentionsNavigationController: UIViewController!
    var accountsNavigationController: UIViewController!
    
    var controllers: [UIViewController] = []
    
    let menuTitle = ["Profile", "Timeline", "Mentions", "Accounts"]
    
    weak var hamburgerViewController: HamburgerViewController! {
        didSet {
            view.layoutIfNeeded()
            hamburgerViewController.contentViewController = controllers[0]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        accountsNavigationController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
        
        controllers.append(profileNavigationController)
        controllers.append(timelineNavigationController)
        controllers.append(mentionsNavigationController)
        controllers.append(accountsNavigationController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        cell.menuText = menuTitle[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hamburgerViewController.contentViewController = controllers[indexPath.row]
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
