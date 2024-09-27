//
//  UIView+Round.swift
//  JFMinimalNotification
//
//  Created by Jeremy E Fox on 9/25/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit

public struct Border {
    let width: CGFloat
    let color: UIColor
}

public extension UIView {
    func makeRound(with border: Border? = nil) {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        var f = frame
        let w = frame.width
        let h = frame.height
        var corner = w
        if h > w { // Portrait
            f.size.height = w
        } else if w > h { // Landscape
            f.size.width = h
            corner = h
        }
        self.frame = f
        self.layer.cornerRadius = corner / 2
        layoutIfNeeded()
        if let border = border {
            self.layer.borderWidth = border.width
            self.layer.borderColor = border.color.cgColor
        }
    }
}
