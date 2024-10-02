//
//  customUIImage.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 14.08.24.
//

import Foundation
import UIKit

extension UIImageView {
    static func customUIImage(name: String, width: CGFloat, height: CGFloat) -> UIImageView {
        let image = UIImage(named: name)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return imageView
    }
    
    static func customUIImages(width: CGFloat, height: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return imageView
    }
}
