//
//  TabViews.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 19.09.24.
//

import SwiftUI

struct TabViews: View {
    @State private var activeTab: Tab = .home
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    var body: some View {
        VStack{
            TabView(selection: $activeTab){
                Text("Hello, Wh")
                    .tag(Tab.home)
                    .toolbar(.hidden, for: .tabBar)
                
                Text("Hello, partners!")
                    .tag(Tab.partners)
                    .toolbar(.hidden, for: .tabBar)
                
                Text("Hello, service!")
                    .tag(Tab.service)
                    .toolbar(.hidden, for: .tabBar)
                
                Text("Hello, activity!")
                    .tag(Tab.activity)
                    .toolbar(.hidden, for: .tabBar)
            }
            customTabBar()
        }
       
    }
    
    @ViewBuilder
    func customTabBar(_ tint: Color = Color("Blue"), _ inactivateTint: Color = .blue) -> some View {
        HStack(alignment: .bottom, spacing: 0){
            ForEach(Tab.allCases , id: \.rawValue) {
                TabItems(tintColor: tint,
                         inactiveCOlor: inactivateTint,
                         tab: $0, 
                         animation: animation,
                         activeTab: $activeTab, 
                         position: $tabShapePosition)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background{
            TabShape(midPoint: tabShapePosition.x)
                .fill(Color.init(uiColor: .tertiarySystemBackground))
                .ignoresSafeArea()
                .shadow(color: .blue.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        }
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}


struct TabItems: View {
    var tintColor: Color
    var inactiveCOlor: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab
    @Binding var position: CGPoint
    @State private var tapPosition: CGPoint = .zero
    var body: some View {
        VStack(spacing: 5){
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundStyle(activeTab == tab ? .white : inactiveCOlor)
                .frame(width:  activeTab == tab ? 58 : 35, height:  activeTab == tab ? 58 : 35 )
                .background{
                    if activeTab == tab {
                        Circle()
                            .fill(.blue.gradient)
                            .matchedGeometryEffect(id: "activeTab", in: animation)
                    
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(activeTab == tab ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: { rect in
            tapPosition.x = rect.midX
            if activeTab == tab {
                position.x = rect.midX
            }
            
        })
        .onTapGesture {
            activeTab = tab
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tapPosition.x
            }
        }
    
    }
}

#Preview {
    TabViews()
}
