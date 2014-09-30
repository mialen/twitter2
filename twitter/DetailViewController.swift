//
//  DetailViewController.swift
//  twitter
//
//  Created by Alena Nikitina on 9/28/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var tweet: Tweet?
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetNumLabel: UILabel!
    @IBOutlet weak var favoriteNumLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var starImg = tweet?.starImg!
        var retweetImg = tweet?.retweetImg!
        
        let starImage = UIImage(named: starImg!) as UIImage
        let retweetImage = UIImage(named: retweetImg!) as UIImage
        
        retweetButton.setBackgroundImage(retweetImage, forState: UIControlState.Normal)
        favoriteButton.setBackgroundImage(starImage, forState: UIControlState.Normal)
        
        userImage.layer.cornerRadius = 5
        userImage.clipsToBounds = true
        
        favoriteLabel.text = "FAVORITES"
        retweetLabel.text = "RETWEETS"

        var retweets = tweet?.retweetCount!
        var favorites = tweet?.favoriteCount!

        retweetNumLabel.text = "\(retweets!)"
        favoriteNumLabel.text = "\(favorites!)"
        
        nameLabel.text = tweet?.user?.name
        
        var username = tweet?.user?.screenname as String?
        usernameLabel.text = "@\(username!)"
        
        messageLabel.text = tweet?.text
        dateLabel.text = tweet?.createdDate
        
        var tmbImage = tweet?.user?.profileImageUrl
        userImage.setImageWithURL(NSURL(string: tmbImage!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        var id = tweet?.idStr

        TwitterClient.sharedInstance.postRetweet(id)
        
        let retweetImage = UIImage(named: "retweet-grn.png") as UIImage
        retweetButton.setBackgroundImage(retweetImage, forState: UIControlState.Normal)
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        var idTweet = tweet?.idStr
        var id = ["id": idTweet!] as NSDictionary
        var fav = tweet?.favorited!
        var imgName: String
        
        if(fav!){
            tweet?.favorited = false
            imgName = "star.png"
        } else {
            tweet?.favorited = true
            imgName = "star-yellow.png"
        }
        
        TwitterClient.sharedInstance.postFavorite(id, isFavorite: tweet?.favorited!)
        
        let favoriteImage = UIImage(named: imgName) as UIImage
        favoriteButton.setBackgroundImage(favoriteImage, forState: UIControlState.Normal)
    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ReplySegue") {
            let navigationController = segue.destinationViewController as UINavigationController
            let myDestVC = navigationController.topViewController as MessageViewController
            myDestVC.replyUser = self.tweet?.user?.screenname as String?
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
