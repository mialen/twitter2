//
//  MenuViewController.swift
//  twitter
//
//  Created by Alena Nikitina on 10/1/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController  {

    @IBOutlet var menuView: UIView!
    @IBOutlet var containerTapGesture: UITapGestureRecognizer!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    lazy var homeViewController: UIViewController = self.getControllerByName("TweetsViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setCurrentController(homeViewController, animated: false)
        containerView.frame = view.frame
    }
    
    override func viewDidLayoutSubviews() {
        menuView.frame.origin.x = -menuView.frame.width
        
        containerTapGesture.enabled = false
    }
    
    func setCurrentController(c: UIViewController, animated: Bool = true) {
        if (animated) {
            hideMenu()
        }
        containerView.frame = UIScreen.mainScreen().bounds
        addChildViewController(c)
        c.view.frame = containerView.frame
        containerView.addSubview(c.view)
        c.didMoveToParentViewController(self)
    }
    
    @IBAction func onDragMenu(sender: UIPanGestureRecognizer) {
        let menuWidth = menuView.frame.width
        let translation = sender.translationInView(containerView)
        if (sender.state == UIGestureRecognizerState.Changed) {
            if (translation.x < 0) {
                self.menuView.frame.origin.x = translation.x
                self.containerView.frame.origin.x = translation.x + menuWidth
            } else if (translation.x > 0) {
                self.menuView.frame.origin.x = translation.x - menuWidth
                self.containerView.frame.origin.x = translation.x
            }
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (translation.x < -menuWidth/2 || (translation.x > 0 && translation.x < menuWidth/2)) {
                hideMenu()
            } else if (translation.x != 0) {
                showMenu()
            }
        }
    }
    
    private func isMenuHidden() -> Bool {
        return !containerTapGesture.enabled
    }
    
    private func hideMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.frame.origin.x = -self.menuView.frame.width
            self.containerView.frame.origin.x = 0
            }) { (s: Bool) -> Void in
                self.containerTapGesture.enabled = false
        }
    }
    
    private func getControllerByName(name: String) -> UIViewController {
        return storyboard?.instantiateViewControllerWithIdentifier(name) as UIViewController
    }
    
    private func showMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.frame.origin.x = 0
            self.containerView.frame.origin.x = self.menuView.frame.width
            }) { (s: Bool) -> Void in
                self.containerTapGesture.enabled = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTimelineShow(sender: AnyObject) {
        hideMenu()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
