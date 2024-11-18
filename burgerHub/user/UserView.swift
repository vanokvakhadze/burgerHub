//
//  UserView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI
import PhotosUI

struct UserView: View {
    var body: some View {
        Text("hello user")
    }
}

struct SideMenuBar: View {
    @State private var userName: String = ""
    @Binding var isShow: Bool
    @State private var photoPickerItem: PhotosPickerItem?
    @StateObject var viewModel =  UserViewModel()
    @ObservedObject var viewModelMain: MainViewModel
    @State var profileImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            VStack(alignment: .leading, spacing: 15) {
                
                if let profilePhoto = profileImage {
                    Image(uiImage: profilePhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                }
                
                Text("\(userName)")
                    .fontWeight(.regular)
                
                Divider()
                ZStack(alignment: .topLeading){
                    
                    PhotosPicker( selection: $photoPickerItem, matching: .images) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(Color(uiColor: .darkGray))
                    }
                    .frame(width: 22, height: 22)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(8)
                    .buttonStyle(BorderedButtonStyle())
                    
                    
                    
                }
                .padding(.top, -85)
                .padding(.leading, 68)
                
                
            }
            .padding(.horizontal)
            .padding(.leading)
            
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 45){
                    NavigationLink(destination: ProfileView()) {
                        tabButton(title: "My Profile", sysImage: "person")
                    }
                    NavigationLink(destination: PaymentView(viewModel: viewModelMain)) {
                        tabButton(title: "Payment method", sysImage: "handbag")
                    }
                    NavigationLink(destination: HistoryView(viewModel: viewModelMain)) {
                        tabButton(title: "History", sysImage: "book")
                    }
                    NavigationLink(destination: HelpView()) {
                        tabButton(title: "Help", sysImage: "ellipsis.message")
                    }
                    Link(destination: URL(string: "https://www.google.com")!) {
                        tabButton(title: "Privacy Policy", sysImage: "list.clipboard")
                    }
                   
                   
                }
                .padding()
                .padding(.horizontal)
                .padding(.top, 35)
            }
            
            LogOutView()
            .frame(width: 100, height: 50)
            .padding(.leading, 21)
            
            
            
        }
        
        .onChange(of: photoPickerItem, { _, _ in
            
            Task{
                if let photoPickerItem,
                   let data = try? await  photoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data){
                        profileImage = image
                        viewModel.saveImageToFileManager(image)
                    
                    }
                }
                photoPickerItem = nil
            }
           
        })
        .onAppear{
            if let fetchedUserName = authService().getUser(service: "IOS dev") {
                userName = fetchedUserName
            }
            if let profile  = viewModel.fetchImageFromFileManager() {
                profileImage = profile
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 63)
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


struct LogOutView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: LogOutVC, context: Context) {
        print("up")
    }
    
    func makeUIViewController(context: Context) -> LogOutVC{
        return LogOutVC()
    }
}
