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
    var ingredients: [Ingredients]
    let price: Double
    let veg: Bool
    var amount: Int
    var isLiked: Bool
    
   
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            price = try container.decode(Double.self, forKey: .price)
            images = try container.decode([ImageSize].self, forKey: .images)
            desc = try container.decode(String.self, forKey: .desc)
            ingredients = try container.decode([Ingredients].self, forKey: .ingredients)
            veg = try container.decode(Bool.self, forKey: .veg)
            amount = 1 // Default value, since it's not provided by the JSON
            isLiked = false
        }
    
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
    var amountOf: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        img = try container.decode(String.self, forKey: .img)
        amountOf = 1 // Default value, since it's not provided by the JSON
    }
}
