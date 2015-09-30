//
//  WidgetTableViewCell.swift
//  Koolendar
//
//  Created by Addison Bean on 9/29/15.
//  Copyright © 2015 INOVA. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
