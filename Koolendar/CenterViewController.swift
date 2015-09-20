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
    
    var someView: UIButton!
    
    func setUserInteraction(aBool: Bool) {
        if !aBool {
            if someView == nil {
                someView = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                someView.backgroundColor = UIColor.blackColor()
                someView.addTarget(delegate!, action: "toggleLeftPanel", forControlEvents: .TouchUpInside)
            }
            someView.alpha = 0.0
            view.addSubview(someView)
            UIView.animateWithDuration(0.2) { self.someView.alpha = 0.4 }
        } else {
            if someView != nil {
                UIView.animateWithDuration(0.2, animations: { self.someView.alpha = 0.0 }, completion: { _ in
                    self.someView.removeFromSuperview()
                })
            }
        }
    }
    
}
