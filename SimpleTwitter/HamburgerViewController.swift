//
//  HamburgerViewController.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet var menuView: UIView!
    @IBOutlet var contentView: UIView!
    
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            
            if animateAddSubView {
                let newFrame = contentViewController.view.frame
                contentViewController.view.frame = newFrame.offsetBy(dx: 0.0, dy: newFrame.height)
                contentView.addSubview(contentViewController.view)
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentViewController.view.frame = newFrame
                })
                animateAddSubView = false
            } else {
                contentView.addSubview(contentViewController.view)
            }
            
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseIn, animations: {
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
            }
        }
    }
    
    var animateAddSubView = false
    
    @IBOutlet var contentViewLeadingConstraint: NSLayoutConstraint!
    var originalContentViewMargin: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanContentView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalContentViewMargin = contentViewLeadingConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            contentViewLeadingConstraint.constant = originalContentViewMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x > 0.0 {
                    let quarterWidth = self.view.frame.width / 4
                    self.contentViewLeadingConstraint.constant = 3 * quarterWidth
                } else {
                    self.contentViewLeadingConstraint.constant = 0
                }
            })
        }
    }
    
    func selectMenu(named menu: String) {
        animateAddSubView = true
        menuViewController.selectMenu(named: menu)
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
