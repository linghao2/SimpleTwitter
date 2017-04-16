//
//  LoginViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/11/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: { 
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }, failure: { (error: Error) in
            print("error: \(error)")
        })
    }
    
}
