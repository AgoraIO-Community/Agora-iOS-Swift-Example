//
//  UIButton+Extensions.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import UIKit

extension UIButton {
    /// Create a custom UIButton made up of one or two SF Symbol images to alternate between
    /// - Parameters:
    ///   - unselected: SF Symbol present by default, when button has not yet been selected
    ///   - selected: SF Symbol to be displayed after the button is selected
    /// - Returns: A new UIButton of type `.custom` which will alternate between the given SF Symbols on selecting
    static func newToggleButton(unselected: String, selected: String? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        if let selected = selected {
            button.setImage(UIImage(
                systemName: selected,
                withConfiguration: UIImage.SymbolConfiguration(scale: .large)
            ), for: .selected)
        }
        button.setImage(UIImage(
            systemName: unselected,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        ), for: .normal)
        return button
    }
}

extension UIView.AutoresizingMask {
    static var all: UIView.AutoresizingMask = [
        .flexibleWidth, .flexibleHeight,
        .flexibleLeftMargin, .flexibleRightMargin,
        .flexibleTopMargin, .flexibleBottomMargin
    ]
}
