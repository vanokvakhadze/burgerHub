//
//  customStackView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 14.08.24.
//

import Foundation
import UIKit

extension UIStackView {
    static func customStackView() ->  UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
    }
}
