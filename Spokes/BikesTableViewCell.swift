//
//  BikesTableViewCell.swift
//  Spokes
//
//  Created by Andrew Barrett on 1/13/17.
//  Copyright © 2017 Andrew Barrett. All rights reserved.
//

import UIKit

class BikesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var bikeImage: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
