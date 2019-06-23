//
//  PostTableViewCell.swift
//  FinalLab
//
//  Created by SWUCOMPUTER on 21/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet var idButton: UIButton!
    @IBOutlet var imageNameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var commentTF: UITextField!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    @IBOutlet var myIdButton: UIButton!
    @IBOutlet var myPostImage: UIImageView!
    
    @IBOutlet var myImageNameLabel: UILabel!
    @IBOutlet var myDateLabel: UILabel!
    @IBOutlet var myCommentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
