//
//  SettingsTableViewCell.swift
//  Koolendar
//
//  Created by Addison Bean on 8/24/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var type: String!

    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(type type: String, options: Any? = nil) {
        self.type = type
        switch self.type {
        case "Bool":
            let uiswitch = UISwitch()
            let f = uiswitch.frame
            uiswitch.frame = CGRect(x: frame.width - f.width - 8, y: (frame.height - f.height) / 2, width: 0, height: 0)
            uiswitch.setOn(options! as! Bool, animated: false)
            addSubview(uiswitch)
        case "MultiValue":
            switch (options as! (String, Any)).0 {
            case "Color Scheme":
                let opts = options as! (String, [(String, String)])
                print(opts.1)
            default:
                print(":(")
            }
            
        default:
            print("frgasgeatgass") // not good
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
