//
//  DesertModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 09.10.24.
//

import Foundation

struct Desserts: Decodable, Identifiable{
    let id: Int
    let name: String
    let price: Int
    let description: String
    let img: String

}
