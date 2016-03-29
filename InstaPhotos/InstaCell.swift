//
//  InstaCell.swift
//  InstaPhotos
//
//  Created by user116136 on 2/27/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol profileTapDelegate: class {
    func didTapProfile(user: PFUser?)
}

class InstaCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var profileView: UIView!
    let profileTap = UITapGestureRecognizer()
    weak var delegate: profileTapDelegate?
    var user: PFUser?
    
    var post: PFObject! {
        didSet {
            //Fill labels with post info
            self.captionLabel.text = post["caption"] as? String
            self.photoImageView.file = post["media"] as? PFFile
            self.photoImageView.loadInBackground()
            self.usernameLabel.text = post["username"] as? String
            
            user = post["author"] as? PFUser
            //If have profile picture
            if let imageFile = user!["profilePic"] as? PFFile {
                self.profileImageView.file = imageFile
                self.profileImageView.loadInBackground()
            //If don't have profile picture use default picture
            } else {
                self.profileImageView.backgroundColor = UIColor.whiteColor()
                self.profileImageView.image = UIImage(named: "flower.png")
            } 
            
            //Format created at date
            let createdAt = post.createdAt!
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = .ShortStyle
            self.createdAtLabel.text = formatter.stringFromDate(createdAt)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //Tap Gesture Recognizer
        profileTap.addTarget(self, action: Selector("onProfileTap:"))
        profileView.addGestureRecognizer(profileTap)
        profileView.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Profile image or user name tapped
    func onProfileTap(recognizer: UITapGestureRecognizer) {
        print("profile view tapped")
        self.delegate?.didTapProfile(user)
    }

}
