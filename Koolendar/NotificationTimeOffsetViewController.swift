//
//  NotificationTimeOffsetViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 9/7/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

protocol NotificationTimeOffsetViewControllerDelegate {
    var offsets: [(String, CFTimeInterval)]! { get }
}

class NotificationTimeOffsetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timePicker: UIPickerView!
    var delegate: NotificationTimeOffsetViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate.offsets.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.delegate.offsets[row].0
    }
}
