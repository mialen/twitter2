//
//  TweetCell.swift
//  twitter
//
//  Created by Alena Nikitina on 9/27/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tweetImage.layer.cornerRadius = 5
        tweetImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
