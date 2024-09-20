//
//  File.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 14.08.24.
//

import Foundation
import UIKit

extension UILabel {
    static func customLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
     func setUnderlinedText(_ text: String) {
          
           
           let attributedString = NSAttributedString(
               string: text,
               attributes: [
                   .underlineStyle: NSUnderlineStyle.single.rawValue,
               ]
           )
           
           self.attributedText = attributedString
       }
}
