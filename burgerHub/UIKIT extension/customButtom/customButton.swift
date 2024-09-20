//
//  customButton.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 15.08.24.
//

import Foundation
import UIKit

extension UIButton {
    static func customButton(width: CGFloat, height: CGFloat, radius: CGFloat) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: width).isActive = true
        btn.heightAnchor.constraint(equalToConstant: height).isActive = true
        btn.layer.cornerRadius = radius
        btn.clipsToBounds = true
        return btn
    }
}
