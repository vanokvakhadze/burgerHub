//
//  FavoriteView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var tabHide: Bool
    var columns = [GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13),
                   GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13)]
    @State var path = NavigationPath()
    @Binding var activeTab: Tab
    
    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                Color(uiColor: .secondarySystemBackground)
                    .ignoresSafeArea()
                VStack{
                    if viewModel.favoriteBurger.isEmpty {
                        
                        Text("there is not favorite burgers yet")
                            .font(.custom("Fira-GO", size: 21))
                            .fontWeight(.regular)
                        
                        
                        
                    } else {
                        ScrollView{
                            LazyVGrid(columns: columns , spacing: 20){
                                ForEach(viewModel.favoriteBurger) { item in
                                    Button {
                                        path.append(item)
                                    } label: {
                                        
                                        BurgerList(viewModel: viewModel, burger: item)
                                            .foregroundColor(.primary)
                                        
                                        
                                    }
                                    
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                        }
                        .padding(.vertical, 15)
                    }
                    
                }
                .navigationDestination(for: Burgers.self)  { item in
                    DetailsView(burger: $viewModel.burgers[item.id],  viewModel: viewModel, path: $path, tabBarHide: $tabHide, activeTab: $activeTab)
                }
                
                .onAppear {
                    DispatchQueue.main.async {
                        tabHide = false
                        
                    }
                }
            }
            .navigationTitle("Favorite Burgers")
        }
    }
}

#Preview {
    FavoriteView(viewModel: MainViewModel(), tabHide: .constant(false), activeTab: .constant(.favorite))
}
