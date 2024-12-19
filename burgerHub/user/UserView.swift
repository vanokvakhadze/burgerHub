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
    @StateObject var viewModel = UserViewModel()
    @ObservedObject var viewModelMain: MainViewModel
    @State var profileImage: UIImage?
    @Binding var path: NavigationPath
    
    @State  var activeView: ActiveView?
    
    var body: some View {
        NavigationStack(path: $path){
            VStack(alignment: .leading, spacing: 0) {
                
                userHeader(photoPickerItem: $photoPickerItem, userName: $userName, profileImage: $profileImage, viewModel: viewModel)
                
                userViewItems(activeView: $activeView, path: $path)
                
                
                LogOutView()
                    .frame(width: 100, height: 50)
                    .padding(.leading, 21)
            }
            
            .onAppear {
                if let fetchedUserName = authService().getUser(service: "IOS dev") {
                    userName = fetchedUserName
                }
                if let profile = viewModel.fetchImageFromFileManager() {
                    profileImage = profile
                }
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: getRect().width - 63)
            .frame(maxHeight: .infinity)
            .background {
                Color.primary
                    .opacity(0.04)
                    .ignoresSafeArea(.container, edges: .vertical)
            }
            .fullScreenCover(item: $activeView) { destination in
                NavigationStack{
                    Group {
                        switch destination{
                        case .profileView:
                            ProfileView()
                        case .paymentView:
                            PaymentView(viewModel: viewModelMain)
                        case .HistoryView:
                            HistoryView(viewModel: viewModelMain)
                        case .MapView:
                            MapView()
                            
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { activeView = nil }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                            .foregroundStyle(.black)
                                            .padding(8)
                                        .background(
                                            Circle()
                                              .fill(Color.init(uiColor: .systemBackground))
                                                .frame(width: 35, height: 35)
                                        )
                                }
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                            }
                        }
                    }
                }
            }
        }
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



enum ActiveView: Hashable, Identifiable {
    
    
    case profileView
    case paymentView
    case HistoryView
    case MapView
    
    var id: String {
        switch self {
        case .profileView: return "profile"
        case .paymentView: return "payment"
        case .HistoryView: return "history"
        case .MapView: return "help"
            
        }
    }
    
}


struct userViewItems: View {
    @Binding var activeView: ActiveView?
    @Binding var path: NavigationPath
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 45) {
                Button(action: {
                    activeView = .profileView
                }) {
                    tabButton(title: "My Profile", sysImage: "person")
                    
                }
                Button(action: { activeView = .paymentView }) {
                    tabButton(title: "Payment method", sysImage: "handbag")
                }
                Button(action: { activeView = .HistoryView }) {
                    tabButton(title: "History", sysImage: "book")
                }
                Button(action: { activeView = .MapView }) {
                    tabButton(title: "Map", sysImage: "mappin.and.ellipse")
                }
                Link(destination: URL(string: "https://www.google.com")!) {
                    tabButton(title: "Privacy Policy", sysImage: "list.clipboard")
                }
            }
            .padding()
            .padding(.horizontal)
            .padding(.top, 35)
        }
        
        
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

struct userHeader: View {
    @Binding var photoPickerItem: PhotosPickerItem?
    @Binding var userName: String
    @Binding var profileImage: UIImage?
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
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
            ZStack(alignment: .topLeading) {
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
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
        .onChange(of: photoPickerItem, { _, _ in
            Task {
                if let photoPickerItem,
                   let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    profileImage = image
                    viewModel.saveImageToFileManager(image)
                }
                photoPickerItem = nil
            }
        })
        
    }
}
