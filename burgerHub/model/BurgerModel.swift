//
//  BurgerModel..swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation
import SwiftData


@Model
class Burgers: Decodable, Identifiable, Hashable, Equatable {
    @Attribute(.unique) var id: Int
    var name: String
    var images: [ImageSize]
    var desc: String
    var ingredients: [Ingredients]
    var price: Double
    var veg: Bool
    var amount: Int
    var isLiked: Bool

   
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            price = try container.decode(Double.self, forKey: .price)
            images = try container.decode([ImageSize].self, forKey: .images)
            desc = try container.decode(String.self, forKey: .desc)
            ingredients = try container.decode([Ingredients].self, forKey: .ingredients)
            veg = try container.decode(Bool.self, forKey: .veg)
            amount = try container.decodeIfPresent(Int.self, forKey: .amount) ?? 1
            isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
    }
    
    private enum CodingKeys: String, CodingKey {
           case id, name, images, desc, ingredients, price, veg, amount, isLiked
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
        amountOf = 1
    }
  
}
