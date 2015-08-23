//
//  SettingsViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/22/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class SettingsViewController: CenterViewController {
    
    @IBAction func showSidebar() {
        self.delegate?.toggleLeftPanel?()
    }
    
}
