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
    case notification = "Notification"
    case basket = "Basket"
    
    
    var systemImage: String {
        switch self {
        case .home :
            return "house"
            
        case .favorite :
            return "suit.heart"
            
        case .notification :
            return "bell.fill"
    
        case .basket :
            return "cart.fill"
        }
    }
    
    var index : Int {
        Tab.allCases.firstIndex(of: self) ?? 0
    }
}
