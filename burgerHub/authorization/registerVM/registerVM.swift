//
//  registerVM.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.08.24.
//

import Foundation
import UIKit


class RegisterVM {
    
    
    
    func registerUser(user: String, password: String, rePassword: String) -> Bool {
        if password == rePassword {
            do {
                try authService().save (
                    service: "IOS dev",
                    account: user,
                    password: password.data(using: .utf8) ?? Data()
                )
                print("success")
                return true
            } catch {
                print()
                return false
            }
        } else {
            print("პაროლები არ ემთხვევა")
            return false
        }
    }
    
    func SingUpWithSocial(value: String, key: String, provider: String) -> Bool{
        let data = Data(value.utf8)
        
        do {
            try authService().save(
                service: "IOS dev",
                account: value,
                password: data
            )
            
            // Save the provider information (for example, "google" or "email")
            try authService().save(
                service: "IOS dev",
                account: "\(value)_provider", // Unique key for provider
                password: Data(provider.utf8) // Save provider as data
            )
            
            
            
            
            print("success")
            return true
        } catch {
            print()
            return false
        }
    }
}
