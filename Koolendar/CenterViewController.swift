//
//  CenterViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/18/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanel()
}

class CenterViewController: UIViewController {

    var delegate: CenterViewControllerDelegate?
    
}
