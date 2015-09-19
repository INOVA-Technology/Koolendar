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
    var selectedOffsetIndex: Int! { get set }
    var timeOffsetLabelText: String { get set }
}

class NotificationTimeOffsetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timePicker: UIPickerView!
    var delegate: NotificationTimeOffsetViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timePicker.selectRow(self.delegate.selectedOffsetIndex, inComponent: 0, animated: false)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate.offsets.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.delegate.offsets[row].0
    }
    
    @IBAction func goBack() {
        let index = self.timePicker.selectedRowInComponent(0)
        self.delegate.selectedOffsetIndex = index
        self.delegate.timeOffsetLabelText = self.delegate.offsets[index].0
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}
