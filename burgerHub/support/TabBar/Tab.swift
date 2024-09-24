//
//  Tab.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 19.09.24.
//

import SwiftUI



enum Tab: String, CaseIterable {
    case home = "Home"
    case favorite = "Favorite"
    case search = "Search"
    case basket = "Basket"
    case service = "Service"
    
    
    var systemImage: String {
        switch self {
        case .home :
            return "house"
        case .favorite :
            return "suit.heart"
        case .search :
            return "magnifyingglass"
        case .basket :
            return "cart.fill"
        case .service :
            return "list.bullet"
        }
    }
    
    var index : Int {
        Tab.allCases.firstIndex(of: self) ?? 0
    }
}
