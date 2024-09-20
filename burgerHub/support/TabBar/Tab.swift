//
//  Tab.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 19.09.24.
//

import SwiftUI



enum Tab: String, CaseIterable {
    case home = "Home"
    case service = "Services"
    case partners = "Partners"
    case activity = "Activity"
    
    
    var systemImage: String {
        switch self {
        case .home :
            return "house"
        case .service :
            return "envelope.open.badge.clock"
        case .partners :
            return "hand.raised"
        case .activity :
            return "bell"
        }
    }
    
    var index : Int {
        Tab.allCases.firstIndex(of: self) ?? 0
    }
}
