//
//  FridgeTableViewCell.swift
//  DigitalFridge
//
//  Created by Zachary Yiu on 12/6/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit

class FridgeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
}
