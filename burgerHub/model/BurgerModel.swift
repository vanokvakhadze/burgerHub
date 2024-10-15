//
//  BurgerModel..swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation
struct BurgerResponse: Codable {
    let data: [Burgers]
}

struct Burgers: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    let images: [ImageSize]
    let desc: String
    let ingredients: [Ingredients]
    let price: Double
    let veg: Bool
    
    static func == (lhs: Burgers, rhs: Burgers) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}

struct ImageSize: Codable {
   
    let sm: String?
    let lg: String?
}

struct Ingredients: Codable, Identifiable {
    var id: Int
    let name: String
    let img: String
}
