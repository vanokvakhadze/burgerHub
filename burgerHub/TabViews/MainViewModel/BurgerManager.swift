//
//  BurgerFetchService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 08.12.24.
//

import Foundation

class BurgerManager {
    private var burgers: [Burgers] = []
    private var isLiked: Bool = false
    private var amount: Int = 1
    
    
    func fetchBurgers() {
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
                    updatedBurger.isLiked = false
                    
                    
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
}
