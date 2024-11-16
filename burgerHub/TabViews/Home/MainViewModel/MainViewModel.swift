//
//  MainViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation

class MainViewModel: ObservableObject, Hashable  {
    @Published var creditCard: [String: [String: String]] = [:]
    var id = 1
    
    @Published var burgers: [Burgers] = []
    @Published var burgerCart: [Burgers] = []
    @Published var boughtBurger = []
    @Published var ingredients: [Ingredients] = []
    @Published var selectedCardType: String? = nil
    @Published var tappedCard: String? = nil
    @Published var cards =  ["Cash", "Visa", "MasterCard", "PayPal" ]
    @Published var searchText: String = ""
    @Published var favoriteBurger: [Burgers] =  []
    @Published var notification: [String] = []
    
    
    var totalPrise: Double {
        burgerCart.reduce(0.0) { $0 + ($1.price * Double($1.amount))}
    }
    
    
    var filteredByname: [Burgers] {
        burgers.filter({$0.name.localizedStandardContains(searchText)})
    }
    
    var totalAmount: Int {
        burgerCart.reduce(0) { $0 +  $1.amount }
    }
    
    var filteredCreditCards: [String: [String: String]] {
        guard let selectedType = selectedCardType, !selectedType.isEmpty else {
            return creditCard // If no type selected, show all cards
        }
        
        return creditCard.filter { $0.value["cardType"] == selectedType }
        
    }
    
    var isLiked: (Burgers) -> String {
        return { burger in
            self.favoriteBurger.contains(where: { $0.id == burger.id }) ? "heart.fill" : "heart"
        }
    }
    
    
    init() {
        
        loadCards()
    }
    
    func loadCards() {
        self.creditCard = fetchAllCards()
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
        if let index = burgerCart.firstIndex(where: { $0.id == burger.id }) {
            burgerCart[index].amount += 1
        } else {
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
    
    
    func fetchAllCards() -> [String: [String: String]] {
        var cards: [String: [String: String]] = [:]
        for key in   CardService.fetchAllCardKeys() {
            let cardNumber =   CardService.fetch(key: "\(key)_number") ?? ""
            let cardHolderName =   CardService.fetch(key: "\(key)_holderName") ?? ""
            let cardExDate =   CardService.fetch(key: "\(key)_exDate") ?? ""
            let cardCvv =   CardService.fetch(key: "\(key)_cvv") ?? ""
            let cardType = CardService.fetch(key: "\(key)_cardType") ?? ""
            cards[key] = ["number": cardNumber, "holderName": cardHolderName, "exDate": cardExDate, "cvv": cardCvv, "cardType": cardType]
        }
        return cards
    }
    
    
    func addNewCard(cardDetails: [String: String]) {
        let uniqueKey = UUID().uuidString
        
        CardService.saveCard(uniqueKey: uniqueKey, cardInfo: cardDetails)
        loadCards()
    }
    
    
    func maskedCardNumber(_ number: String) -> String {
        
        let cleanedNumber = number.replacingOccurrences(of: " ", with: "")
        guard cleanedNumber.count > 3 else { return number }
        
        let maskedPart = String(repeating: "*", count: cleanedNumber.count - 3)
        let lastThreeDigits = cleanedNumber.suffix(3)
        return maskedPart + " " + lastThreeDigits
    }
    
    func deleteCard(uniqueKey: String) {
        
        CardService.delete(key: "\(uniqueKey)_number")
        CardService.delete(key: "\(uniqueKey)_holderName")
        CardService.delete(key: "\(uniqueKey)_exDate")
        CardService.delete(key: "\(uniqueKey)_cvv")
        CardService.delete(key: "\(uniqueKey)_cardType")
        
        var keys = CardService.fetchAllCardKeys()
        if let index = keys.firstIndex(of: uniqueKey) {
            keys.remove(at: index)
            UserDefaults.standard.setValue(keys, forKey: "savedCardKeys")
        }
        
        loadCards()
    }
    
    func clearBurgerCart() {
        
        boughtBurger.append(contentsOf: burgerCart)
        burgerCart.removeAll()
      
    }
    
    func clickHeartButton(burger: Burgers) {
        if favoriteBurger.contains(where: { $0.id == burger.id }) {
            favoriteBurger.removeAll(where: {$0.id == burger.id })
          
        } else {
            
            favoriteBurger.append(burger)
        }
    }
    
}

