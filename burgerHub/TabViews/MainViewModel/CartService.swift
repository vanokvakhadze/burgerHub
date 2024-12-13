//
//  CartService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 07.12.24.
//

import Foundation

class CartService {
    var burgers: [Burgers] = []
    var burgerCart: [Burgers] = []
    
    
    func getAmount(of burger: Burgers)  -> Int{
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id }) {
            return burgerCart[index].amount
        } else {
            return  burger.amount
        }
    }
    
    
    func addBurger(of burger: Burgers) {
        if let index = burgers.firstIndex(where: { $0.id == burger.id }) {
            burgers[index].amount += 1
        }
        
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id }) {
            burgerCart[index].amount += 1
        } else {
            burgerCart.append(burger)
        }
    }
    
    func decreaseBurger(of burger: Burgers){
        if let index = burgers.firstIndex(where: { $0.id == burger.id}){
            if burgers[index].amount > 1 {
                burgers[index].amount -= 1
            }
        }
        
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id}){
            if burgerCart[index].amount > 1 {
                burgerCart[index].amount -= 1
            }
        }
    }
    
}

extension CartService{
    var totalAmount: Int {
        burgerCart.reduce(0) { $0 +  $1.amount }
    }
    
    var totalPrise: Double {
        burgerCart.reduce(0.0) { $0 + ($1.price * Double($1.amount))}
    }
    
}
