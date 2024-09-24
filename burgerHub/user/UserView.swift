//
//  UserView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        Text("hello user")
    }
}

struct SideMenuBar: View {
    @State private var userName: String = ""
    @Binding var isShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                Text("\(userName)")
                    .fontWeight(.regular)
                
                Divider()
            }
            .padding(.horizontal)
            .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 45){
                    NavigationLink(destination: ProfileView()) {
                        tabButton(title: "My Profile", sysImage: "person")
                    }
                    NavigationLink(destination: PaymentView()) {
                        tabButton(title: "Payment method", sysImage: "handbag")
                    }
                    NavigationLink(destination: SettingView()) {
                        tabButton(title: "Settings", sysImage: "gearshape.2")
                    }
                    NavigationLink(destination: HelpView()) {
                        tabButton(title: "Help", sysImage: "ellipsis.message")
                    }
                    NavigationLink(destination: PrivacyView()) {
                        tabButton(title: "Privacy Policy", sysImage: "list.clipboard")
                    }
                    
                }
                .padding()
                .padding(.horizontal)
                .padding(.top, 35)
            }
            
            Button{
                
            } label: {
                Text("Log Out")
                    .foregroundStyle(.white)
                
            }
            .frame(width: 100, height: 50)
            .background(.buttonC)
            .cornerRadius(20)
            .padding(.leading, 21)
            
        }
        .onAppear{
            if let fetchedUserName = authService().getUser(service: "IOS dev") {
                userName = fetchedUserName
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background{
            Color.primary
                .opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func tabButton(title: String, sysImage: String) -> some View {
        
            HStack(spacing: 15){
                Image(systemName: sysImage)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 22, height: 22)
                Text(title)
                
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    
}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}


