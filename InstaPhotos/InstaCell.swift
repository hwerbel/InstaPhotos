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

class InstaCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoImageView: PFImageView!

    var post: PFObject! {
        didSet {
            self.captionLabel.text = post["caption"] as? String
            self.photoImageView.file = post["media"] as? PFFile
            self.photoImageView.loadInBackground()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
