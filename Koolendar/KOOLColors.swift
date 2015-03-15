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
    case Dark
}

struct ColorScheme {
    
    static var currentTheme: ColorForScheme = .Dark

    
    // change these awful colors to something aestheticly pleasing
    // also, these color names are too specific as far as usage goes, but idk how else to name them
    
    static var background: UIColor {
        switch currentTheme {
        case .Dark:
            return UIColor.blackColor().colorWithAlphaComponent(0.9)
        }
    }
    
    static var dayCell: UIColor {
        switch currentTheme {
        case .Dark:
            return UIColor.blackColor().colorWithAlphaComponent(0.4)
        }
    }
    
    static var dayCell2: UIColor {
        switch currentTheme {
        case .Dark:
            return UIColor.whiteColor().colorWithAlphaComponent(0.1)
        }
    }
    
    static var currentDayCell: UIColor {
        switch currentTheme {
        case .Dark:
            return UIColor(red: 128/255, green: 219/255, blue: 255/255, alpha: 0.7)
        }
    }
    
}