//
//  UIColor+JFMinimalNotificationColors.swift
//  JFMinimalNotification
//
//  Created by Jeremy E Fox on 9/25/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit

private struct JFColor {
    static let notificationGreenColor: UIColor = createColor(145, 77, 80)
    
    static let notificationRedColor: UIColor = createColor(6, 74, 91)
    
    static let notificationYellowColor: UIColor = createColor(48, 83, 100)
    
    static let notificationBlueColor: UIColor = createColor(224, 50, 63)
    
    static let notificationBlackColor: UIColor = createColor(0, 0, 17)
    
    static let notificationWhiteColor: UIColor = createColor(192, 2, 95)
    
    static let notificationOrangeColor: UIColor = createColor(28, 85, 90)
    
    static private func createColor(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(hue: h/360, saturation: s/100, brightness: b/100, alpha: 1)
    }
}

public extension UIColor {
    
    static var notificationGreenColor: UIColor {
        return JFColor.notificationGreenColor
    }
    
    static var notificationRedColor: UIColor {
        return JFColor.notificationRedColor
    }

    static var notificationYellowColor: UIColor {
        return JFColor.notificationYellowColor
    }

    static var notificationBlueColor: UIColor {
        return JFColor.notificationBlueColor
    }

    static var notificationBlackColor: UIColor {
        return JFColor.notificationBlackColor
    }

    static var notificationWhiteColor: UIColor {
        return JFColor.notificationWhiteColor
    }

    static var notificationOrangeColor: UIColor {
        return JFColor.notificationOrangeColor
    }
}
