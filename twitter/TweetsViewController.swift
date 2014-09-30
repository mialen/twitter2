//
//  TweetsViewController.swift
//  twitter
//
//  Created by Alena Nikitina on 9/27/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]? = []
    var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.backgroundColor = UIColor(red: 1.0, green: 0.81, blue: 0.19, alpha: 1.0)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        loadTweets()
    }
    
    func loadTweets() {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func refresh(sender:AnyObject) {
        //self.activityIndicator.startAnimating()
        loadTweets()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell

        var tweet = self.tweets![indexPath.row]
        var userName = tweet.user?.screenname as String?

        cell.nameLabel.text = tweet.user?.name as String?
        cell.usernameLabel.text = "@\(userName!)"
        cell.dateLabel.text = tweet.createdDate as String?
        cell.messageLabel.text = tweet.text as String?
        
        var tmbImage = tweet.user?.profileImageUrl as String?
        cell.tweetImage.setImageWithURL(NSURL(string: tmbImage!))
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "DetailSegue") {
            let myDestVC = segue.destinationViewController as DetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
            myDestVC.tweet = self.tweets![indexPath.row]
        }

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
