//
//  BurgerList.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 10.10.24.
//

import SwiftUI
import SwiftData

struct BurgerList: View {
    @ObservedObject var viewModel: MainViewModel
    var burger: Burgers
    @Environment(\.modelContext) private var context

    

    var body: some View {
        ZStack(alignment: .bottomTrailing){
          
            VStack{
                
                ZStack(alignment: .topTrailing) {
                    ForEach(burger.images, id: \.sm) { img in
                        fetchImage(imageURL: img.lg ?? "" , width: 120, height: 60)
                            .padding(.top, 10)
                    }
                    
                    ZStack{
                        sysImage(image: viewModel.filterFavorites(burger: burger) ? "heart.fill" : "heart", width: 16, height: 16)
                            .foregroundStyle(.red)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(uiColor: .secondarySystemBackground))
                                    .frame(width: 22, height: 22)
                            )
                            .padding(.top, 10)
                            .padding(.trailing, -17)
                            .onTapGesture {
                                viewModel.toggleLikedButton(burger: burger, context: context)
                            }
                    }
                }
                Spacer()
                    .frame(height: 15)
                
                HStack{
                    Text("\(burger.name)")
                        .frame(height: 30)
                        .font(.custom("DM Sans", size: 14))
                    
                    Spacer()
                }
                .padding(.leading, 10)
                
                Spacer()
                    .frame(height: 10)
                
                HStack{
                    
                    
                    Text("$")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(width: 5)
                    Text("\(String(format: "%.1f", burger.price))")
                        .font(.system(size: 14))
                        .foregroundStyle(.green)
                    
                    Spacer()
                }
                .padding(.leading, 10)
                
            }
            .padding(.bottom, 20)
            .background(Color.init(uiColor: .systemBackground))
            .clipShape(.rect(cornerRadius: 20))
            
            ZStack{
                sysImage(image: "plus", width: 13, height: 13)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.buttonC)
                    )
                    .onTapGesture {
                        
                        viewModel.addToCart(burger: burger)
                        
                    }
                
                
                
            }
            .padding(.bottom, 15)
            .padding(.trailing, 25)
        }
    }
  
}




//#Preview {
//    HomeView(isShown: .constant(false), viewModel: MainViewModel(), activeTab: .constant(.home), tabBarHide: .constant(false))
//}
