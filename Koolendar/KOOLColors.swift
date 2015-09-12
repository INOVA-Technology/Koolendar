//
//  KOOLColors.swift
//  Koolendar
//
//  Created by Addison Bean on 1/23/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import UIKit

enum ColorSchemeStyle: String {
    case RedAurora = "RedAurora"
    case MidnightEpiphany = "MidnightEpiphany"
}

struct ColorScheme {
    
    static var currentTheme: ColorSchemeStyle = .RedAurora
    
    static var background: UIImage {
        switch currentTheme {
        case .RedAurora:
            return UIImage(named:"SimpleBg")!
        case .MidnightEpiphany:
            return UIImage(named: "idk")!
        }
    }
    
    static var dayCellEven: UIColor {
        switch currentTheme {
        case .RedAurora:
            return UIColor.blackColor().colorWithAlphaComponent(0.4)
        case .MidnightEpiphany:
            return UIColor.blackColor().colorWithAlphaComponent(0.4)
        }
    }
    
    static var dayCellOdd: UIColor {
        switch currentTheme {
        case .RedAurora:
            return UIColor.whiteColor().colorWithAlphaComponent(0.1)
        case .MidnightEpiphany:
            return UIColor.whiteColor().colorWithAlphaComponent(0.1)
        }
    }
    
    static var currentDayCell: UIColor {
        switch currentTheme {
        case .RedAurora:
            return UIColor(red: 128/255, green: 219/255, blue: 255/255, alpha: 0.7)
        case .MidnightEpiphany:
            return UIColor(red: 128/255, green: 219/255, blue: 255/255, alpha: 0.7)
        }
    }
    
}