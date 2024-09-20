//
//  LoginVM.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.08.24.
//

import Foundation
import UIKit


class LoginVM {
    
    
    
    func Login(user: String, password: String) -> Bool {
       
        guard let data = authService().get(service: "IOS dev", account: user),
        let storedPassword = String(data: data, encoding: .utf8) else { return
            false  }
        
        if storedPassword == password {
            print("success")
            return true
        } else {
            print("fail")
            return false
        }
        
       
        
    }
}
