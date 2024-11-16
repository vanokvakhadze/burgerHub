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
    @State  var showMenu: Bool = false
    @State var offset: CGFloat  = 0
    @State var lastStoredOffset: CGFloat  = 0
    @GestureState var gestureOffset: CGFloat = 0
    @ObservedObject var viewModel = MainViewModel()
    @State var path = NavigationPath()
    @State var tabBarshow = false
    
    
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        let sideBarWidth = getRect().width - 65
        
            
            HStack(spacing: 0){
                
                SideMenuBar(isShow: $showMenu, viewModelMain: viewModel)
                
                VStack{
                    TabView(selection: $activeTab){
                        
                        HomeView(isShown: $showMenu, viewModel: viewModel, activeTab: $activeTab, tabBarHide: $tabBarshow)
                        
                            .tag(Tab.home)
                        
                        
                        FavoriteView(viewModel: viewModel, tabHide: $tabBarshow, activeTab: $activeTab )
                            .tag(Tab.favorite)
                        
                        
                        NotificationView(viewModel: viewModel)
                            .tag(Tab.notification)
                        
                        CartView(viewModel: viewModel, tabHide: $tabBarshow, activeTab: $activeTab)
                            .tag(Tab.basket)
                        
                        
                    }
                    .toolbar(.hidden, for: .tabBar)  
                    if !tabBarshow {
                        customTabBar()
                    }
                }
                
                .frame(width: getRect().width)
                .overlay{
                    Rectangle()
                        .fill(
                            Color.primary.opacity(Double(offset / sideBarWidth) / 5)
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            withAnimation{
                                showMenu.toggle()
                            }
                        }
                }
                
                .onChange(of: activeTab) {
                    tabBarshow = false
                }
                
                
                
            }
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset > 0 ? offset : 0)
            .gesture(
                DragGesture()
                    .updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded(onEnd(value:  ))
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        
        .animation(.easeInOut, value: offset == 0)
        .onChange(of: showMenu) { newValue, prev in
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset) {onChange()}
    }
    
    func onChange(){
        let sideBarWidth = getRect().width - 65
        offset = (gestureOffset != 0 ) ? (gestureOffset + lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset : offset ) : offset
    }
    
    func onEnd(value: DragGesture.Value) {
        let sideBarWidth = getRect().width - 65
        let transition = value.translation.width
        withAnimation{
            if transition > 0 {
                
                if transition > (sideBarWidth / 2) {
                    offset = sideBarWidth
                    showMenu = true
                } else {
                    
                    if offset == sideBarWidth {
                        return
                    }
                    offset = 0
                    showMenu = false
                }
                
            } else {
                
                if -transition > (sideBarWidth / 2) {
                    offset = 0
                    showMenu = false
                } else {
                    
                    if offset == 0 || !showMenu {
                        return
                    }
                    offset = sideBarWidth
                    showMenu = true
                }
            }
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
                         position: $tabShapePosition,
                         viewModel: viewModel)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .frame(height: 60)
        .background{
            TabShape(midPoint: tabShapePosition.x)
                .fill(Color.init(uiColor: .tertiarySystemBackground))
                .ignoresSafeArea()
                .shadow(color: .buttonC.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .frame(height: 75)
            
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
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 5){
            if tab == .basket && viewModel.totalAmount > 0 {
                cartViewAmount()
                
            } else  if tab == .notification && !viewModel.notification.isEmpty {
                
                notificationAmount()
                
                
            } else {
                Image(systemName: tab.systemImage)
                    .font(.title2)
                    .foregroundStyle(activeTab == tab ? .white : .gray)
                    .frame(width:  activeTab == tab ? 58 : 35, height:  activeTab == tab ? 58 : 35 )
                    .background{
                        if activeTab == tab {
                            Circle()
                                .fill(.buttonC.gradient)
                                .matchedGeometryEffect(id: "activeTab", in: animation)
                            
                        }
                    }
            }
            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(activeTab == tab ? .buttonC : .gray)
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
    
    
    func cartViewAmount() -> some View {
        ZStack{
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundStyle(activeTab == tab ? .white : .gray)
                .frame(width:  activeTab == tab ? 58 : 35, height:  activeTab == tab ? 58 : 35 )
                .background{
                    if activeTab == tab {
                        Circle()
                            .fill(.buttonC.gradient)
                            .matchedGeometryEffect(id: "activeTab", in:  animation)
                        
                    }
                }
            
            ZStack{
                Text("\(viewModel.totalAmount)")
                    .font(.system(size: activeTab == tab ? 14 : 10))
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(.red)
                            .frame(width: activeTab == tab ? 20 : 17, height: activeTab == tab ? 20 : 17)
                    )
            }
            .padding(.leading, activeTab == tab ? 31 : 25)
            .padding(.bottom,  activeTab == tab ? 26 : 15)
        }
    }
    
    func notificationAmount() -> some View {
        ZStack{
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundStyle(activeTab == tab ? .white : .gray)
                .frame(width:  activeTab == tab ? 64 : 35, height:  activeTab == tab ? 65 : 35 )
                .background{
                    if activeTab == tab {
                        Circle()
                            .fill(.buttonC.gradient)
                            .matchedGeometryEffect(id: "activeTab", in:  animation)
                        
                    }
                }
            
            ZStack{
                Text("\(viewModel.notification.count)")
                    .font(.system(size: activeTab == tab ? 14 : 10))
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(.red)
                            .frame(width: activeTab == tab ? 20 : 17, height: activeTab == tab ? 20 : 17)
                    )
            }
            .padding(.leading, activeTab == tab ? 21 : 19)
            .padding(.bottom,  activeTab == tab ? 24 : 20)
        }
    }
    
}

#Preview {
    TabViews()
}


extension UITabBar {
    static func hide() {
        UIView.animate(withDuration: 0.3) {
            UITabBar.appearance().alpha = 0
        }
    }
    
    static func show() {
        UIView.animate(withDuration: 0.3) {
            UITabBar.appearance().alpha = 1
        }
    }
}
