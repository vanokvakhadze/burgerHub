//
//  MainViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation

class MainViewModel: ObservableObject, Hashable  {
    
    
    var id = 1
    
    @Published var burgers: [Burgers] = []
    @Published var burgerCart: [Burgers] = []
    @Published var ingredients: [Ingredients] = []
    
    
    var totalPrise: Double {
        burgerCart.reduce(0.0) { $0 + ($1.price * Double($1.amount))}
    }
    

    
    func fetchData() {
        let headers = [
            "x-rapidapi-key": "ee8e6ad656msh1622ed26a2ea971p11ddb1jsn86cfe5139e63",
            "x-rapidapi-host": "burgers-hub.p.rapidapi.com"
        ]
        
        let urlString = "https://burgers-hub.p.rapidapi.com/burgers"
        
        if let url = URL(string: urlString) {
            CachingService().fetchData(from: url, headers: headers) { result in
                guard let fetchedBurgers = result else {
                    return
                }
                
             
                let modifiedBurgers = fetchedBurgers.map { burger -> Burgers in
                    var updatedBurger = burger
                    updatedBurger.amount = 1
                    
                   
                    let updatedIngredients = updatedBurger.ingredients.map { ingredient -> Ingredients in
                        var updatedIngredient = ingredient
                        updatedIngredient.amountOf = 1
                        return updatedIngredient
                    }
                    
                    updatedBurger.ingredients = updatedIngredients
                    return updatedBurger
                }
            
               
                DispatchQueue.main.async {
                    self.burgers = modifiedBurgers
                }
            }
        }
    }
    
    func addBurger(of burger: Burgers) {
        if let index = burgers.firstIndex(where: { $0.id == burger.id }) {
            burgers[index].amount += 1
        }
       
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id }) {
            burgerCart[index].amount += 1
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
    
    func addToCart(burger: Burgers)  {
        if !burgerCart.contains(where: { $0.id == burger.id }) {
                burgerCart.append(burger)
            }
            
        }
    
    
    func getAmount(of burger: Burgers)  -> Int{
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id }) {
            return burgerCart[index].amount
        } else {
          return  burger.amount
        }
    }
    
    func getAmountIngredients(of ingredient: Ingredients, in burger: Burgers)  -> Int{
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id }),
           let ingredientIndex = burgerCart[index].ingredients.firstIndex(where: {$0.id == ingredient.id}){
            return burgerCart[index].ingredients[ingredientIndex].amountOf
        } else {
            
            return  burger.ingredients.first(where: { $0.id == ingredient.id })?.amountOf ?? 1
        }
    }
    
    func addIngredients(of ingredient: Ingredients, in burger: Burgers) {
            if let burgerIndex = burgers.firstIndex(where: { $0.id == burger.id }),
               let ingredientIndex = burgers[burgerIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                burgers[burgerIndex].ingredients[ingredientIndex].amountOf += 1
            } 
       
        
        if let burgerIndex = burgerCart.firstIndex(where: { $0.id == burger.id }),
               let ingredientIndex = burgerCart[burgerIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            burgerCart[burgerIndex].ingredients[ingredientIndex].amountOf += 1
            }
        }
    
    func decreaseIngredients(of ingredient:   Ingredients, in burger: Burgers){
       
           if let burgerCartIndex = burgers.firstIndex(where: { $0.id == burger.id }) {
               if let ingredientIndex = burgers[burgerCartIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }),
                  burgers[burgerCartIndex].ingredients[ingredientIndex].amountOf > 0 {
                   burgers[burgerCartIndex].ingredients[ingredientIndex].amountOf -= 1
               }
           } 
        
        if let burgerCartIndex = burgerCart.firstIndex(where: { $0.id == burger.id }) {
               if let ingredientIndex = burgerCart[burgerCartIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }),
                  burgerCart[burgerCartIndex].ingredients[ingredientIndex].amountOf > 1 {
                   burgerCart[burgerCartIndex].ingredients[ingredientIndex].amountOf -= 1
               }
           }
    }
    
    
    
    static func == (lhs: MainViewModel, rhs: MainViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

