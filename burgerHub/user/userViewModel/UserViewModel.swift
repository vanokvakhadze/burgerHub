//
//  UserViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 20.08.24.
//

import Foundation

protocol UserDelegate: AnyObject {
    func updateUserView()
}

class UserViewModel {
    let auth = authService()
    
    weak var delegate: UserDelegate?
    
    func getUser(){
       // auth.getUser(service: "IOS dev")
        delegate?.updateUserView()
    }
    
    func logOut(service: String, account: String) -> Bool{
        do{
            try authService().deletePassword(service: service, account: account)
            return true
        }catch{
            print("delete error")
            return false
        }
    }
    
    
}
