//
//  JFMinimalNotificationArt.swift
//  JFMinimalNotification
//
//  Created by Jeremy E Fox on 9/25/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit

class JFMinimalNotificationArt {

    private(set) static var imageOfCheckmarkColor: UIColor? = nil
    private(set) static var imageOfCheckmark: UIImage? = nil
    private(set) static var imageOfCrossColor: UIColor? = nil
    private(set) static var imageOfCross: UIImage? = nil
    private(set) static var imageOfNoticeColor: UIColor? = nil
    private(set) static var imageOfNotice: UIImage? = nil
    private(set) static var imageOfWarningColor: UIColor? = nil
    private(set) static var imageOfWarning: UIImage? = nil
    private(set) static var imageOfInfoColor: UIColor? = nil
    private(set) static var imageOfInfo: UIImage? = nil
    private(set) static var imageOfEditColor: UIColor? = nil
    private(set) static var imageOfEdit: UIImage? = nil
    
    private static func drawCheckmark(with color: UIColor) {
        let bezier3Path = UIBezierPath()
        
        bezier3Path.move(to: CGPointMake(8, 37))
        bezier3Path.addLine(to: CGPointMake(27, 56))
        bezier3Path.move(to: CGPointMake(27, 56))
        bezier3Path.addLine(to: CGPointMake(75, 8))
        bezier3Path.lineCapStyle = .round
        
        color.setStroke()
        
        bezier3Path.lineWidth = 14;
        bezier3Path.stroke()
    }

    private static func drawCross(with color: UIColor) {
        let bezier3Path = UIBezierPath()
        
        bezier3Path.move(to: CGPointMake(10, 10))
        bezier3Path.addLine(to: CGPointMake(53, 53))
        bezier3Path.move(to: CGPointMake(10, 53))
        bezier3Path.addLine(to: CGPointMake(53, 10))
        bezier3Path.lineCapStyle = .round
        
        color.setStroke()
        
        bezier3Path.lineWidth = 11;
        bezier3Path.stroke()
    }
    
    private static func drawNotice(with color: UIColor) {
        // Notice Shape Drawing
        let noticeShapePath = UIBezierPath()
        
        noticeShapePath.move(to: CGPoint(x: 72, y: 48.54))
        noticeShapePath.addLine(to: CGPoint(x: 72, y: 39.9))
        noticeShapePath.addCurve(to: CGPoint(x: 66.38, y: 34.01), controlPoint1: CGPoint(x: 72, y: 36.76), controlPoint2: CGPoint(x: 69.48, y: 34.01))
        noticeShapePath.addCurve(to: CGPoint(x: 61.53, y: 35.97), controlPoint1: CGPoint(x: 64.82, y: 34.01), controlPoint2: CGPoint(x: 62.69, y: 34.8))
        noticeShapePath.addCurve(to: CGPoint(x: 60.36, y: 35.78), controlPoint1: CGPoint(x: 61.33, y: 35.97), controlPoint2: CGPoint(x: 62.3, y: 35.78))
        noticeShapePath.addLine(to: CGPoint(x: 60.36, y: 33.22))
        noticeShapePath.addCurve(to: CGPoint(x: 54.16, y: 26.16), controlPoint1: CGPoint(x: 60.36, y: 29.3), controlPoint2: CGPoint(x: 57.65, y: 26.16))
        noticeShapePath.addCurve(to: CGPoint(x: 48.73, y: 29.89), controlPoint1: CGPoint(x: 51.64, y: 26.16), controlPoint2: CGPoint(x: 50.67, y: 27.73))
        noticeShapePath.addLine(to: CGPoint(x: 48.73, y: 28.71))
        noticeShapePath.addCurve(to: CGPoint(x: 43.49, y: 21.64), controlPoint1: CGPoint(x: 48.73, y: 24.78), controlPoint2: CGPoint(x: 46.98, y: 21.64))
        noticeShapePath.addCurve(to: CGPoint(x: 39.03, y: 25.37), controlPoint1: CGPoint(x: 40.97, y: 21.64), controlPoint2: CGPoint(x: 39.03, y: 23.01))
        noticeShapePath.addLine(to: CGPoint(x: 39.03, y: 9.07))
        noticeShapePath.addCurve(to: CGPoint(x: 32.24, y: 2), controlPoint1: CGPoint(x: 39.03, y: 5.14), controlPoint2: CGPoint(x: 35.73, y: 2))
        noticeShapePath.addCurve(to: CGPoint(x: 25.45, y: 9.07), controlPoint1: CGPoint(x: 28.56, y: 2), controlPoint2: CGPoint(x: 25.45, y: 5.14))
        noticeShapePath.addLine(to: CGPoint(x: 25.45, y: 41.47))
        noticeShapePath.addCurve(to: CGPoint(x: 24.29, y: 43.44), controlPoint1: CGPoint(x: 25.45, y: 42.45), controlPoint2: CGPoint(x: 24.68, y: 43.04))
        noticeShapePath.addCurve(to: CGPoint(x: 9.55, y: 43.04), controlPoint1: CGPoint(x: 16.73, y: 40.88), controlPoint2: CGPoint(x: 11.88, y: 40.69))
        noticeShapePath.addCurve(to: CGPoint(x: 8, y: 46.58), controlPoint1: CGPoint(x: 8.58, y: 43.83), controlPoint2: CGPoint(x: 8, y: 45.2))
        noticeShapePath.addCurve(to: CGPoint(x: 14.4, y: 55.81), controlPoint1: CGPoint(x: 8.19, y: 50.31), controlPoint2: CGPoint(x: 12.07, y: 53.84))
        noticeShapePath.addLine(to: CGPoint(x: 27.2, y: 69.56))
        noticeShapePath.addCurve(to: CGPoint(x: 42.91, y: 77.8), controlPoint1: CGPoint(x: 30.5, y: 74.47), controlPoint2: CGPoint(x: 35.73, y: 77.21))
        noticeShapePath.addCurve(to: CGPoint(x: 43.88, y: 77.8), controlPoint1: CGPoint(x: 43.3, y: 77.8), controlPoint2: CGPoint(x: 43.68, y: 77.8))
        noticeShapePath.addCurve(to: CGPoint(x: 47.18, y: 78), controlPoint1: CGPoint(x: 45.04, y: 77.8), controlPoint2: CGPoint(x: 46.01, y: 78))
        noticeShapePath.addLine(to: CGPoint(x: 48.34, y: 78))
        noticeShapePath.addLine(to: CGPoint(x: 48.34, y: 78))
        noticeShapePath.addCurve(to: CGPoint(x: 71.61, y: 52.08), controlPoint1: CGPoint(x: 56.48, y: 78), controlPoint2: CGPoint(x: 69.87, y: 75.05))
        noticeShapePath.addCurve(to: CGPoint(x: 72, y: 48.54), controlPoint1: CGPoint(x: 71.81, y: 51.29), controlPoint2: CGPoint(x: 72, y: 49.72))
        noticeShapePath.close()
        noticeShapePath.miterLimit = 4
        
        color.setFill()
        noticeShapePath.fill()
    }
    
    private static func drawWarning(with backgroundColor: UIColor, and foregroundColor: UIColor) {
        // Bezier Drawing
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 54, y: 10))
        bezierPath.addLine(to: CGPoint(x: 11, y: 81))
        bezierPath.addLine(to: CGPoint(x: 54, y: 81))
        bezierPath.addLine(to: CGPoint(x: 97, y: 81))
        bezierPath.addLine(to: CGPoint(x: 54, y: 10))
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        
        backgroundColor.setFill()
        bezierPath.fill()
        
        backgroundColor.setStroke()
        bezierPath.lineWidth = 14
        bezierPath.stroke()
        
        // Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 54, y: 48))
        bezier2Path.addLine(to: CGPoint(x: 54, y: 71))
        bezier2Path.lineCapStyle = .round
        bezier2Path.lineJoinStyle = .round
        
        foregroundColor.setFill()
        bezier2Path.fill()
        
        foregroundColor.setStroke()
        bezier2Path.lineWidth = 14
        bezier2Path.stroke()
        
        // Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 47, y: 19, width: 14, height: 14))
        foregroundColor.setFill()
        ovalPath.fill()
    }
    
    private static func drawInfo(with color: UIColor) {
        // Info Shape Drawing
        let infoShapePath = UIBezierPath()
        
        infoShapePath.move(to: CGPoint(x: 45.66, y: 15.96))
        infoShapePath.addCurve(to: CGPoint(x: 45.66, y: 5.22), controlPoint1: CGPoint(x: 48.78, y: 12.99), controlPoint2: CGPoint(x: 48.78, y: 8.19))
        infoShapePath.addCurve(to: CGPoint(x: 34.34, y: 5.22), controlPoint1: CGPoint(x: 42.53, y: 2.26), controlPoint2: CGPoint(x: 37.47, y: 2.26))
        infoShapePath.addCurve(to: CGPoint(x: 34.34, y: 15.96), controlPoint1: CGPoint(x: 31.22, y: 8.19), controlPoint2: CGPoint(x: 31.22, y: 12.99))
        infoShapePath.addCurve(to: CGPoint(x: 45.66, y: 15.96), controlPoint1: CGPoint(x: 37.47, y: 18.92), controlPoint2: CGPoint(x: 42.53, y: 18.92))
        infoShapePath.close()
        
        infoShapePath.move(to: CGPoint(x: 48, y: 69.41))
        infoShapePath.addCurve(to: CGPoint(x: 40, y: 77), controlPoint1: CGPoint(x: 48, y: 73.58), controlPoint2: CGPoint(x: 44.4, y: 77))
        infoShapePath.addLine(to: CGPoint(x: 40, y: 77))
        infoShapePath.addCurve(to: CGPoint(x: 32, y: 69.41), controlPoint1: CGPoint(x: 35.6, y: 77), controlPoint2: CGPoint(x: 32, y: 73.58))
        infoShapePath.addLine(to: CGPoint(x: 32, y: 35.26))
        infoShapePath.addCurve(to: CGPoint(x: 40, y: 27.67), controlPoint1: CGPoint(x: 32, y: 31.08), controlPoint2: CGPoint(x: 35.6, y: 27.67))
        infoShapePath.addLine(to: CGPoint(x: 40, y: 27.67))
        infoShapePath.addCurve(to: CGPoint(x: 48, y: 35.26), controlPoint1: CGPoint(x: 44.4, y: 27.67), controlPoint2: CGPoint(x: 48, y: 31.08))
        infoShapePath.addLine(to: CGPoint(x: 48, y: 69.41))
        infoShapePath.close()
        
        color.setFill()
        infoShapePath.fill()
    }
    
    private static func drawEdit(with color: UIColor) {
        // Edit shape Drawing
        let editPath = UIBezierPath()
        
        editPath.move(to: CGPoint(x: 71, y: 2.7))
        editPath.addCurve(to: CGPoint(x: 71.9, y: 15.2), controlPoint1: CGPoint(x: 74.7, y: 5.9), controlPoint2: CGPoint(x: 75.1, y: 11.6))
        editPath.addLine(to: CGPoint(x: 64.5, y: 23.7))
        editPath.addLine(to: CGPoint(x: 49.9, y: 11.1))
        editPath.addLine(to: CGPoint(x: 57.3, y: 2.6))
        editPath.addCurve(to: CGPoint(x: 69.7, y: 1.7), controlPoint1: CGPoint(x: 60.4, y: -1.1), controlPoint2: CGPoint(x: 66.1, y: -1.5))
        editPath.addLine(to: CGPoint(x: 71, y: 2.7))
        editPath.addLine(to: CGPoint(x: 71, y: 2.7))
        editPath.close()
        
        editPath.move(to: CGPoint(x: 47.8, y: 13.5))
        editPath.addLine(to: CGPoint(x: 13.4, y: 53.1))
        editPath.addLine(to: CGPoint(x: 15.7, y: 55.1))
        editPath.addLine(to: CGPoint(x: 50.1, y: 15.5))
        editPath.addLine(to: CGPoint(x: 47.8, y: 13.5))
        editPath.addLine(to: CGPoint(x: 47.8, y: 13.5))
        editPath.close()
        
        editPath.move(to: CGPoint(x: 17.7, y: 56.7))
        editPath.addLine(to: CGPoint(x: 23.8, y: 62.2))
        editPath.addLine(to: CGPoint(x: 58.2, y: 22.6))
        editPath.addLine(to: CGPoint(x: 52, y: 17.1))
        editPath.addLine(to: CGPoint(x: 17.7, y: 56.7))
        editPath.addLine(to: CGPoint(x: 17.7, y: 56.7))
        editPath.close()
        
        editPath.move(to: CGPoint(x: 25.8, y: 63.8))
        editPath.addLine(to: CGPoint(x: 60.1, y: 24.2))
        editPath.addLine(to: CGPoint(x: 62.3, y: 26.1))
        editPath.addLine(to: CGPoint(x: 28.1, y: 65.7))
        editPath.addLine(to: CGPoint(x: 25.8, y: 63.8))
        editPath.addLine(to: CGPoint(x: 25.8, y: 63.8))
        editPath.close()
        
        editPath.move(to: CGPoint(x: 25.9, y: 68.1))
        editPath.addLine(to: CGPoint(x: 4.2, y: 79.5))
        editPath.addLine(to: CGPoint(x: 11.3, y: 55.5))
        editPath.addLine(to: CGPoint(x: 25.9, y: 68.1))
        editPath.close()
        
        editPath.miterLimit = 4
        editPath.usesEvenOddFillRule = true
        
        color.setFill()
        editPath.fill()
    }
    
    static func imageOfCheckmark(with color: UIColor) -> UIImage? {
        if let imageOfCheckmark, imageOfCheckmarkColor == color {
            return imageOfCheckmark
        }
        
        imageOfCheckmarkColor = color
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(85, 63), false, 0);
        drawCheckmark(with: color)
        imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfCheckmark
    }
    
    static func imageOfCross(color: UIColor) -> UIImage? {
        if let existingImage = imageOfCross, imageOfCrossColor == color {
            return existingImage
        }
        
        imageOfCrossColor = color
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 63, height: 63), false, 0)
        drawCross(with: color)
        imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        return imageOfCross
    }
    
    static func imageOfNotice(color: UIColor) -> UIImage? {
        if let existingImage = imageOfNotice, imageOfNoticeColor == color {
            return existingImage
        }
        
        imageOfNoticeColor = color
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        drawNotice(with: color)
        imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        return imageOfNotice
    }
    
    static func imageOfWarning(with backgroundColor: UIColor, and foregroundColor: UIColor) -> UIImage? {
        if let existingImage = imageOfWarning, imageOfWarningColor == backgroundColor {
            return existingImage
        }
        
        imageOfWarningColor = backgroundColor
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 108, height: 92), false, 0)
        drawWarning(with: backgroundColor, and: foregroundColor)
        imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfWarning
    }
    
    static func imageOfInfo(with color: UIColor) -> UIImage? {
        if let existingImage = imageOfInfo, imageOfInfoColor == color {
            return existingImage
        }
        
        imageOfInfoColor = color
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        drawInfo(with: color)
        imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfInfo
    }
    
    static func imageOfEdit(with color: UIColor) -> UIImage? {
        if let existingImage = imageOfEdit, imageOfEditColor == color {
            return existingImage
        }
        
        imageOfEditColor = color
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        drawEdit(with: color)
        imageOfEdit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageOfEdit
    }
}
