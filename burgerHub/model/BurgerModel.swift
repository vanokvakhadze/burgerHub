//
//  model.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation
struct BurgerResponse: Codable {
    let data: [Burgers]
}

struct Burgers: Codable, Identifiable {
    let id: Int
    let name: String
    let images: [ImageSize]
    let desc: String
    let ingredients: [Ingredients]
    let price: Double
    let veg: Bool
    
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
