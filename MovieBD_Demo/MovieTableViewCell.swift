//
//  MovieTableViewCell.swift
//  MovieBD_Demo
//
//  Created by Cntt28 on 5/17/17.
//  Copyright © 2017 Cntt28. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
