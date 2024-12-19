//
//  HomeView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var isShown: Bool
    @ObservedObject var viewModel: MainViewModel
    @Binding var activeTab: Tab
    var columns = [GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13),
                   GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13)]
    
    @State var path = NavigationPath()
    @Binding var tabBarHide: Bool
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        
    NavigationStack(path: $path){
            ZStack{
                
                Color(uiColor: UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    
                    VStack(spacing: 20){
                        
                        HStack{
                            
                            Spacer()
                                .frame(width: 20)
                            
                            Button{
                                withAnimation{isShown.toggle()}
                            } label: {
                                
                                sysImage(image: "list.bullet", width: 15, height: 15)
                                    .foregroundStyle(.black)
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.init(uiColor: .systemBackground))
                            .cornerRadius(15)
                            
                            Spacer()
                        }
                        
                        searchBar()
                            .padding(.horizontal, 20)
                        
                        
                        if viewModel.searchText.isEmpty {
                            HStack{
                                Spacer()
                                    .frame(width: 22)
                                
                                Text("Burgers")
                                    .font(.custom("FiraGO-Bold", size: 20))
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                            }
                            .padding(.top, 5)
                            
                            
                            
                            LazyVGrid(columns: columns , spacing: 20){
                                ForEach(viewModel.burgers) { item in
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
                            
                        } else {
                            ForEach(viewModel.filteredByname) { item in
                                
                                Button {
                                    path.append(item)
                                } label: {
                                    
                                    searchList(burger: item, viewModel: viewModel)
                                        .foregroundColor(.primary)
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
                .navigationDestination(for: Burgers.self)  { item in
                    DetailsView(burger: $viewModel.burgers[item.id],  viewModel: viewModel, path: $path, tabBarHide: $tabBarHide, activeTab: $activeTab)
                }
                
                
                .onAppear {
                    DispatchQueue.main.async {
                        tabBarHide = false
                        viewModel.fetchData()
                        viewModel.fetchBurgers(context: context)
                    }
                   
                   
                }
            }
            
        }
    }
    
    @ViewBuilder
    func searchBar() -> some View{
        HStack(spacing: 12) {
            sysImage(image: "magnifyingglass", width: 18, height: 18)
            
            TextField("Search burgers", text: $viewModel.searchText)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .frame(height: 45)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
            
        )
    }
    
}

//#Preview {
//    HomeView(isShown: .constant(false), viewModel: MainViewModel(), activeTab: .constant(.home), tabBarHide: .constant(false))
//}

struct searchList: View {
    var burger: Burgers
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        SearchList(burger:burger, viewModel: viewModel){
            
            ZStack{
                sysImage(image: "plus", width: 15, height: 15)
                    .foregroundStyle(.background)
                    .background(
                        Circle()
                            .fill(.buttonC)
                            .frame(width: 25, height: 25)
                    )
                    .onTapGesture {
                        viewModel.addToCart(burger: burger)
                        
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 15)
            }
            
        }
        
    }
}
