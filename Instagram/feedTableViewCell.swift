//
//  feedTableViewCell.swift
//  Instagram
//
//  Created by harshvardhan singh on 8/24/19.
//  Copyright © 2019 harshvardhan singh. All rights reserved.
//

import UIKit

class feedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCaptions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
