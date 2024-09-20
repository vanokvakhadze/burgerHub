//
//  alertExtension.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.08.24.
//

import Foundation
import UIKit

extension UIViewController{
    func sendAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
           self.present(alert, animated: true, completion: nil)
       }
    func sendDestructiveAlert(message: String, title: String, type: UIAlertAction.Style){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: type))
        self.present(alert, animated: true)
    }
}
