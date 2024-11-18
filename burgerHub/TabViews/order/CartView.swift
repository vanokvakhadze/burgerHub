//
//  CartView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 15.10.24.


import SwiftUI

struct CartView: View {
    
    @State var path =  NavigationPath()
    @ObservedObject var viewModel: MainViewModel
    @Binding var tabHide: Bool
    @Binding var activeTab: Tab
    
    
    var body: some View {
        NavigationStack(path: $path){
            ZStack {
                Color(uiColor: UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Text("Your Cart")
                                    .font(.custom("FiraGO-Regular", size: 20))
                                Spacer()
                            }
                            
                            ForEach(viewModel.burgerCart, id: \.id) { items in
                                Button {
                                    path.append(DestinationCart.ingredients(items))
                                } label: {
                                    cartList(item: items, viewModel: viewModel)
                                        .foregroundColor(.primary)
                                }
                            }
                            
                        }
                    }
                    
                    
                    ZStack(alignment: .bottom) {
                        Color(uiColor: .systemBackground)
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                Text("Total")
                                Spacer()
                                Text("$ \(String(format: "%.1f", viewModel.totalPrise))")
                                Spacer()
                                    .frame(width: 20)
                            }
                            .frame(width: 330, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                            )
                            
                            Spacer()
                                .frame(height: 26)
                            
                            Button("Place Order", action: {
                                path.append(DestinationCart.OrderView(viewModel))
                            })
                            .frame(width: 280, height: 50)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(.buttonC)
                            )
                            
                            Spacer()
                                .frame(height: 50)
                        }
                        .padding(.vertical, 20)
                    }
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color(uiColor: .tertiarySystemGroupedBackground), radius: 1)
                    .padding(.bottom, -50)
                    
                }
                .navigationBarBackButtonHidden()
                .navigationDestination(for: DestinationCart.self) { destination in
                    switch destination {
                    case .ingredients(let burger):
                        if let index = viewModel.burgerCart.firstIndex(where: { $0.id == burger.id }) {
                            IngredientsView(burger: $viewModel.burgerCart[index], viewModel: viewModel, path: $path)
                        }
                    case .OrderView(_):
                        OrderView(viewModel: viewModel, path: $path, tabHide: $tabHide, activeTab: $activeTab)
                        
                        
                    }
                }
            }
            .onAppear{
                tabHide = false
            }
        }
    }
    //struct CartView_Previews: PreviewProvider {
    //
    //    static var previews: some View {
    ////
    ////        CartView( burger: $burger, path: .constant(NavigationPath()), viewModel: MainViewModel())
    //
    //    }
    //}
    struct cartList: View {
        var item: Burgers
        @ObservedObject var viewModel: MainViewModel
        
        var body: some View {
            if viewModel.burgerCart.isEmpty {
                Text("there is nothing added")
                    .font(.custom("Fira-GO", size: 20))
                    .fontWeight(.regular)
            } else {
                ZStack{
                  
                    SearchList(burger: item, viewModel: viewModel){
                        
                        ZStack{
                            HStack{
                                sysImage(image: "minus.circle", width: 22, height: 22)
                                    .foregroundStyle(.white)
                                    .background(
                                        Circle()
                                            .fill(.buttonC)
                                    )
                                    .onTapGesture {
                                        
                                        viewModel.decreaseBurger(of: item)
                                    }
                                
                                
                                Text("\(item.amount)")
                                    .font(.system(size: 18))
                                
                                
                                sysImage(image: "plus.circle", width: 22, height: 22)
                                    .foregroundStyle(.white)
                                    .background(
                                        Circle()
                                            .fill(.buttonC)
                                    )
                                    .onTapGesture {
                                        
                                        viewModel.addBurger(of: item)
                                    }
                            }
                            
                        }
                        .padding(.bottom, 20)
                        .padding(.trailing, 15)
                        
                        
                    }
                        Spacer()
                }
                .frame(width: 335, height: 120)
                .background(Color.init(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.vertical, 10)
            }
        }
        
    }
}

enum DestinationCart: Hashable {
    
    case ingredients(Burgers)
    case OrderView(MainViewModel)
    
}
