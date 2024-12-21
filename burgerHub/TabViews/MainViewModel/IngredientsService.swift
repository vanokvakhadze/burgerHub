//
//  IngredientsService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 07.12.24.
//

import Foundation

class IngredientsService {
    static let shared = IngredientsService()
    
    func getAmountIngredients(of ingredient: Ingredients, in burger: Burgers, in viewModel: MainViewModel)  -> Int{
        if let index = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }),
           let ingredientIndex = viewModel.burgerCart[index].ingredients.firstIndex(where: {$0.id == ingredient.id}){
            return viewModel.burgerCart[index].ingredients[ingredientIndex].amountOf
        } else {
            
            return  burger.ingredients.first(where: { $0.id == ingredient.id })?.amountOf ?? 1
        }
    }
    
    func addIngredients(of ingredient: Ingredients, in burger: Burgers, in viewModel: MainViewModel) {
        if let burgerIndex = viewModel.burgers.firstIndex(where: { $0.id == burger.id }),
               let ingredientIndex = viewModel.burgers[burgerIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                viewModel.burgers[burgerIndex].ingredients[ingredientIndex].amountOf += 1
            }
        
            if let cartIndex = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
                if let ingredientIndex = viewModel.burgerCart[cartIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                    viewModel.burgerCart[cartIndex].ingredients[ingredientIndex].amountOf = viewModel.burgers.first(where: { $0.id == burger.id })?.ingredients.first(where: { $0.id == ingredient.id })?.amountOf ?? 1
                }
            } else {
                var burgerInCart = burger
                if let index = viewModel.burgers.firstIndex(where: { $0.id == burger.id }) {
                    burgerInCart.ingredients = viewModel.burgers[index].ingredients
                }
                viewModel.burgerCart.append(burgerInCart)
            }
    }
    
    func decreaseIngredients(of ingredient:   Ingredients, in burger: Burgers, in viewModel: MainViewModel){
  
          if let burgerIndex = viewModel.burgers.firstIndex(where: { $0.id == burger.id }),
             let ingredientIndex = viewModel.burgers[burgerIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }),
             viewModel.burgers[burgerIndex].ingredients[ingredientIndex].amountOf > 0 {
              viewModel.burgers[burgerIndex].ingredients[ingredientIndex].amountOf -= 1
          }
          
          if let cartIndex = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
              if let ingredientIndex = viewModel.burgerCart[cartIndex].ingredients.firstIndex(where: { $0.id == ingredient.id }),
                 viewModel.burgerCart[cartIndex].ingredients[ingredientIndex].amountOf > 0 {
                  viewModel.burgerCart[cartIndex].ingredients[ingredientIndex].amountOf = viewModel.burgers.first(where: { $0.id == burger.id })?.ingredients.first(where: { $0.id == ingredient.id })?.amountOf ?? 0
              }
          }
    }
    
    

}
