//
//  TabViews.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 19.09.24.
//

import SwiftUI

struct TabViews: View {
    @State private var activeTab: Tab = .home
    
    var body: some View {
        VStack{
            TabView {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Text("Hello, World!")
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
       
    }
}

#Preview {
    TabView()
}
