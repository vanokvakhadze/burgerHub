//
//  CardService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 07.12.24.
//

import SwiftUI


protocol CardHandling {
    func loadCards()
    func addNewCard(cardDetails: [String: String])
    func deleteCard(uniqueKey: String)
    func maskedCardNumber(_ number: String) -> String
    var filteredCreditCards: [String: [String: String]] { get }
}

class CardManager: ObservableObject, CardHandling {
    @Published var creditCard: [String: [String: String]] = [:]
    @Published var selectedCardType: String? = nil
    @Published var cards = ["Cash", "Visa", "MasterCard", "PayPal"]

    func loadCards() {
        self.creditCard = fetchAllCards()
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

    func deleteCard(uniqueKey: String) {
        CardService.delete(key: "\(uniqueKey)_number")
        CardService.delete(key: "\(uniqueKey)_holderName")
        CardService.delete(key: "\(uniqueKey)_exDate")
        CardService.delete(key: "\(uniqueKey)_cvv")
        CardService.delete(key: "\(uniqueKey)_cardType")

        loadCards()
    }

    func maskedCardNumber(_ number: String) -> String {
        let cleanedNumber = number.replacingOccurrences(of: " ", with: "")
        guard cleanedNumber.count > 3 else { return number }
        let maskedPart = String(repeating: "*", count: cleanedNumber.count - 3)
        let lastThreeDigits = cleanedNumber.suffix(3)
        return maskedPart + " " + lastThreeDigits
    }

    var filteredCreditCards: [String: [String: String]] {
        guard let selectedType = selectedCardType, !selectedType.isEmpty else {
            return creditCard // If no type selected, show all cards
        }
        return creditCard.filter { $0.value["cardType"] == selectedType }
    }
}