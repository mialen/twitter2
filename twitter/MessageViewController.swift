//
//  MessageViewController.swift
//  twitter
//
//  Created by Alena Nikitina on 9/28/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var currentUser = User.currentUser
    var replyUser: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userImage.layer.cornerRadius = 5
        userImage.clipsToBounds = true
        
        nameLabel.text = currentUser?.name
        
        var username = currentUser?.screenname as String?
        usernameLabel.text = "@\(username!)"
        
        var tmbImage = currentUser?.profileImageUrl
        
        userImage.setImageWithURL(NSURL(string: tmbImage!))
        
        if(replyUser != nil) {
            tweetTextView.text = "@\(replyUser!)"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    @IBAction func handleTweetButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            var status = ["status":self.tweetTextView.text] as NSDictionary
            TwitterClient.sharedInstance.postTweet(status)
        })
        
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
