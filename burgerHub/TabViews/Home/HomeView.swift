//
//  HomeView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI

struct HomeView: View {
    @Binding var isShown: Bool
    @StateObject var viewModel = MainViewModel()
    var columns = [GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13),
                   GridItem(.adaptive(minimum: 100, maximum: 170), spacing: 13)]
    
    @State  var path = NavigationPath()
    @State  var burger = Burgers.self
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{
                HStack{
                    Spacer()
                        .frame(width: 20)
                    Button{
                        withAnimation{isShown.toggle()}
                    } label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                        
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.init(uiColor: .secondarySystemBackground))
                    .cornerRadius(15)
                    
                    Spacer()
                }
                
                ScrollView{
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
                    .background(Color.init(uiColor: .systemGroupedBackground))
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

#Preview {
    HomeView(isShown: .constant(false))
}
