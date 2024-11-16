//
//  NotificationView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.11.24.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        NavigationStack{
            ZStack{
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                VStack{
                    if viewModel.notification.isEmpty {
                        
                        Text("you don't have any notification")
                            .font(.custom("Fira-GO", size: 18))
                            .fontWeight(.regular)
                        
                        
                    } else {
                        ScrollView {
                            
                        }
                    }
                }
                .padding(.vertical, 10)
            
            }
            .navigationTitle("Notification")
        }
       
    }
}

#Preview {
    NotificationView(viewModel: MainViewModel())
}
