//
//  PizzaModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 09.10.24.
//

import Foundation

struct Pizza: Decodable, Identifiable {
    let id: Int
    let name: String
    let veg: Bool
    let price: Int
    let description: String
    let img: String
    let sizeandcrust: [PizzaSize]
  
}

struct PizzaSize: Decodable {
    let medium: [Price]
    let large: [Price]
    let exLarge: [Price]
    
    
    enum CodingKeys: String, CodingKey {
        case medium = "mediumPan"
        case large = "mediumstuffedcrustcheesemax"
        case exLarge = "medium stuffed crust-veg kebab"
    }
    
}
struct Price: Decodable {
    let price: Int
}
