//
//  ProfileView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 24.09.24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            UIKitView()
        }
        .ignoresSafeArea(.all)
    }
}


struct UIKitView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UserVC, context: Context) {
        print("up")
    }
    
    func makeUIViewController(context: Context) -> UserVC{
        return UserVC()
    }
}

#Preview {
    ProfileView()
}
