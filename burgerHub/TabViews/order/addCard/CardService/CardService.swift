//
//  CardService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 29.10.24.
//

import Foundation

struct CardService{
    
    static func save(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
       
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
    

    static func fetch(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    
    
    static func fetchAllCardKeys() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "savedCardKeys") ?? []
    }
    
    
    
    static func fetchAllCards() -> [String: [String: String]] {
        var cards: [String: [String: String]] = [:]
        for key in fetchAllCardKeys() {
            let cardNumber = fetch(key: "\(key)_number") ?? ""
            let cardHolderName = fetch(key: "\(key)_holderName") ?? ""
            let cardExDate = fetch(key: "\(key)_exDate") ?? ""
            let cardCvv = fetch(key: "\(key)_cvv") ?? ""
            let cardType = fetch(key: "\(key)_cardType") ?? ""
            cards[key] = ["number": cardNumber, "holderName": cardHolderName, "exDate": cardExDate, "cvv": cardCvv, "cardType": cardType]
        }
        return cards
    }
    
    
    static func saveCard(uniqueKey: String, cardInfo: [String: String]) {
        save(key: "\(uniqueKey)_number", value: cardInfo["number"] ?? "")
        save(key: "\(uniqueKey)_holderName", value: cardInfo["holderName"] ?? "")
        save(key: "\(uniqueKey)_exDate", value: cardInfo["exDate"] ?? "")
        save(key: "\(uniqueKey)_cvv", value: cardInfo["cvv"] ?? "")
        save(key: "\(uniqueKey)_cardType", value: cardInfo["cardType"] ?? "")
        
        
        var keys = fetchAllCardKeys()
        keys.append(uniqueKey)
        UserDefaults.standard.setValue(keys, forKey: "savedCardKeys")
    }
    
    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Successfully deleted item for key: \(key)")
        } else {
            print("Failed to delete item for key: \(key). Error code: \(status)")
        }
    }
}
