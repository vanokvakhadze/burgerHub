//
//  HomeView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI

struct HomeView: View {
    @Binding var isShown: Bool
    @ObservedObject var viewModel: MainViewModel
    var columns = [GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13),
                   GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13)]
    
    @State  var path = NavigationPath()
    @State  var burger = Burgers.self
    
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
                    DetailsView(burger: $viewModel.burgers[item.id],  viewModel: viewModel, path: $path)
                }
                
                
                .onAppear {
                    viewModel.fetchData()
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

#Preview {
    HomeView(isShown: .constant(false), viewModel: MainViewModel())
}

struct searchList: View {
    var burger: Burgers
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            
            ZStack{
                sysImage(image: "plus", width: 15, height: 15)
                    .foregroundStyle(.background)
                    .background(
                        Circle()
                            .fill(.buttonC)
                            .frame(width: 25, height: 25)
                    )
                    .onTapGesture {
                        print("clicked")
                    }
                
                
                    .padding(.trailing, 30)
                    .padding(.bottom, 15)
            }
            
            
            
            HStack(spacing: 10){
                Spacer()
                    .frame(width: 15)
                
                ForEach(burger.images, id: \.sm) { item in
                    fetchImage(imageURL: item.sm ?? "", width: 70, height: 70)
                }
                
                
                VStack(spacing: 15 ){
                    HStack{
                        Text(burger.name)
                        
                            .font(.custom("Sen", size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        Spacer()
                        
                    }
                    
                    HStack{
                        Text("$")
                            .font(.custom("Sen", size: 15))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("\(String(format: "%.1f", burger.price))")
                            .font(.custom("Sen", size: 15))
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                
            }
            .frame(width: 347, height: 90)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.background)
                
            )
            
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
