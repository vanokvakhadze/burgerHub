//
//  MainViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation
import SwiftData
import SwiftUI


class MainViewModel: ObservableObject, Hashable  {
    static let shared = MainViewModel()
    var id = 1
    @Published var creditCard: [String: [String: String]] = [:]
    @Published var burgers: [Burgers] = []
    @Published var burgerCart: [Burgers] = []
    @Published var boughtBurger: [Burgers]  = []
    @Published var ingredients: [Ingredients] = []
    @Published var selectedCardType: String? = nil
    @Published var tappedCard: String? = nil
    @Published var cards =  ["Cash", "Visa", "MasterCard", "PayPal" ]
    @Published var searchText: String = ""
    @Published var notification: [String] = []
    @Published var colorSets: [String] = ["green1",  "green2", "green3", "green4", "green5", "green6"]
    @Published var favoriteBurgers: [Burgers] = []
    
    private var ingredientsManager = IngredientsService.shared
    private var burgerManager = BurgerManager.shared
    private var cardManager = CardManager.shared
   
    
    init(){
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
                    let updatedBurger = burger
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
        burgerManager.addBurger(of: burger, in: self)
    }
    
    func decreaseBurger(of burger: Burgers){
        burgerManager.decreaseBurger(of: burger, in: self)
    }
    
    func addToCart(burger: Burgers)  {
        burgerManager.addToCart(burger: burger, in: self)
    }
    
    
    func getAmount(of burger: Burgers)  -> Int{
        burgerManager.getAmount(of: burger, in: self)
    }
    
    func getAmountIngredients(of ingredient: Ingredients, in burger: Burgers)  -> Int{
        ingredientsManager.getAmountIngredients(of: ingredient, in: burger, in: self)
    }
    
    func addIngredients(of ingredient: Ingredients, in burger: Burgers) {
        ingredientsManager.addIngredients(of: ingredient, in: burger, in: self)
    }
    
    func decreaseIngredients(of ingredient:   Ingredients, in burger: Burgers){
        ingredientsManager.decreaseIngredients(of: ingredient, in: burger, in: self)
    }
    
    
    func fetchAllCards() -> [String: [String: String]] {
        cardManager.fetchAllCards()
    }
    
    
    func addNewCard(cardDetails: [String: String]) {
        cardManager.addNewCard(cardDetails: cardDetails)
        loadCards()
    }
    
    
    
    
    func deleteCard(uniqueKey: String) {
        cardManager.deleteCard(uniqueKey: uniqueKey, viewModel: self)
        loadCards()
    }
    
    
    
}

extension MainViewModel: ColorBurgerList {
    func clearBurgerCart() {
        burgerManager.clearBurgerCart(in: self)
    }
    
    
    func colorOfBoughtBurgers(index: Int) -> String {
        let colorIndex = index % colorSets.count
        return colorSets[colorIndex]
        
    }
    
    func maskedCardNumber(_ number: String) -> String {
        cardManager.maskedCardNumber(number)
    }
    
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
        guard let selectedType = selectedCardType else {
            return creditCard
        }
        
        return creditCard.filter { $0.value["cardType"] == selectedType }
        
    }
    
    static func == (lhs: MainViewModel, rhs: MainViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
   

    func fetchBurgers(context: ModelContext) {
        let request = FetchDescriptor<Burgers>()
           do {
               favoriteBurgers = try context.fetch(request)
               
           } catch {
               print("Fetch error: \(error)")
           }
       }
   
    func toggleLikedButton(burger: Burgers, context: ModelContext) {
        if filterFavorites(burger: burger){
            deleteBurger(burger,  context)
           
        }else {
            favoriteBurgers.append(burger)
            context.insert(burger)
        }
        saveContext(context: context)
    }
    
    func filterFavorites(burger: Burgers) -> Bool {
        favoriteBurgers.contains(where: {$0.id == burger.id})
        }
    
    
    private func deleteBurger(_ burger: Burgers, _ context: ModelContext) {
        let predicate = #Predicate<Burgers> { burger in
            burger.id == burger.id
        }
        
        let request = FetchDescriptor<Burgers>(predicate: predicate)
        
        do {
            if let existingBurger = try context.fetch(request).first {
             
                context.delete(existingBurger)
                print("Deleting burger with id: \(existingBurger.id)")
                
                if let index = favoriteBurgers.firstIndex(where: { $0.id == existingBurger.id }) {
                    favoriteBurgers.remove(at: index)
                    print("Burger removed from the array: \(existingBurger.id)")
                }
                
             
            } else {
                print("Burger not found in context.")
            }
        } catch {
            print("Error fetching burger from context: \(error)")
        }
    }


        
        private func saveContext(context: ModelContext) {
            do {
                try context.save()
                //fetchBurgers(context: context)
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    
}

protocol ColorBurgerList {
    func colorOfBoughtBurgers(index: Int) -> String
}
