//
//  KOOLColors.swift
//  Koolendar
//
//  Created by Addison Bean on 1/23/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import UIKit

enum ColorForScheme {
    case Blue
}

struct ColorScheme {
    
    static var currentTheme: ColorForScheme = .Blue

    
    // change these awful colors to something aestheticly pleasing
    // also, these color names are too specific as far as usage goes, but idk how else to name them
    
    static var background: UIColor {
        switch currentTheme {
        case .Blue:
            return UIColor.darkGrayColor()
        }
    }
    
    static var dayCell: UIColor {
        switch currentTheme {
        case .Blue:
            return UIColor.cyanColor()
        }
    }
    
    static var currentDayCell: UIColor {
        switch currentTheme {
        case .Blue:
            return UIColor.blueColor()
        }
    }
    
}