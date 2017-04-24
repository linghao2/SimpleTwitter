//
//  AccountsViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var users: [User] = []
    
    var panCell: AccountTableViewCell?
    var panCellIndexPath: IndexPath?
    var originalContentViewMargin: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let swipePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGustureRecognizer(recognizer:)))
        tableView.addGestureRecognizer(swipePanRecognizer)
        
        let user = User.currentUser
        if user != nil {
            users.append(user!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onPanGustureRecognizer(recognizer: UIPanGestureRecognizer) {
        print("onPanGustureRecognizer")
        let velocity = recognizer.velocity(in: view)
        let translation = recognizer.translation(in: view)
        if recognizer.state == UIGestureRecognizerState.began {
            print("*start")
            panCell = nil
            let location = recognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                print("indexPath: \(indexPath)")
                if indexPath.row <= users.count {
                    panCell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell
                    panCellIndexPath = indexPath
                    originalContentViewMargin = panCell!.cellLeadingConstraint.constant
                }
            }
        } else if recognizer.state == UIGestureRecognizerState.changed {
            print("*changed")
            if panCell != nil && velocity.x > 0 {
                panCell!.cellLeadingConstraint.constant = originalContentViewMargin + translation.x
            }
        } else if recognizer.state == UIGestureRecognizerState.ended {
            print("*ended")
            if panCell != nil {
                let width = panCell!.frame.width
                print("/(width)")
                if translation.x > width/2 {
                    users.remove(at: panCellIndexPath!.row)
                    tableView.deleteRows(at: [panCellIndexPath!], with: .automatic)
                    tableView.reloadData()
                } else {
                    panCell?.cellLeadingConstraint.constant = originalContentViewMargin
                }
            }
            panCell = nil
            panCellIndexPath = nil
            originalContentViewMargin = 0.0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = users.count + 1
        if indexPath.row == count-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateAccountCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsCell", for: indexPath) as! AccountTableViewCell
            cell.selectionStyle = .none
            cell.user = users[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row <= users.count {
                users.remove(at: indexPath.row)
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
