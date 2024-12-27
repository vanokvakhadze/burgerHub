//
//  BurgerFetchService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 08.12.24.
//

import Foundation


protocol BurgerFavorite{
    func clickHeartButton(burger: Burgers, in viewModel: MainViewModel)
}


class BurgerManager {
    
    static let shared = BurgerManager()
    
    private let headers = [
               "x-rapidapi-key": "27a6606d57msh2fdc635268fefd1p1bfe7ajsn309aa932fe0f",
               "x-rapidapi-host": "exercisedb.p.rapidapi.com"
           ]
           
    private let urlString = "https://exercisedb.p.rapidapi.com/exercises?limit=250&offset=0"
           
   
    func addToCart(burger: Burgers, in viewModel: MainViewModel) {
        if let index = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
            viewModel.burgerCart[index].amount += 1
        } else {
            viewModel.burgerCart.append(burger)
        }
    }
    
    func NavigateToCart(burger: Burgers, in viewModel: MainViewModel) {
        if let index = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
            viewModel.burgerCart[index].amount =  viewModel.burgers[index].amount
        }
    }
  
    
    func addBurger(of burger: Burgers, in viewModel: MainViewModel) {
      

           if let cartIndex = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
              burger.amount += 1
               viewModel.burgers[cartIndex].amount = viewModel.burgerCart[cartIndex].amount
           } else {
               let burgerInCart = burger
               burgerInCart.amount += 1
           }
    }
    
    func decreaseBurger(of burger: Burgers, in viewModel: MainViewModel){

        if burger.amount > 1 {
            burger.amount -= 1
        }else {
            viewModel.burgerCart.removeAll(where: { $0.id == burger.id })
        }
    }
    
    func getAmount(of burger: Burgers, in viewModel: MainViewModel)  -> Int{
        if let index = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
            return viewModel.burgerCart[index].amount
        } else {
            return  burger.amount
        }
    }
}




extension BurgerManager {
  
    
    func clearBurgerCart(in viewModel: MainViewModel) {
        viewModel.boughtBurger.append(contentsOf: viewModel.burgerCart)
        viewModel.burgerCart.removeAll()
    }
    
//    
//    func clickHeartButton(burger: Burgers, in viewModel: MainViewModel) {
//        if viewModel.favoriteBurger.contains(where: { $0.id == burger.id }) {
//            viewModel.favoriteBurger.removeAll { $0.id == burger.id }
//        } else {
//            viewModel.favoriteBurger.append(burger)
//        }
//    }
}
