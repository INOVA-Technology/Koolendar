//
//  EventCell.swift
//  Koolendar
//
//  Created by Chase on 2/28/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    var rowIndex: Int!
    
    @IBAction func editEvent(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showEditMenu", object: self.rowIndex)
    }
    
}
