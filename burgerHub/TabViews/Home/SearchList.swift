//
//  SearchList.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 18.11.24.
//

import SwiftUI

struct SearchList<Content:View>: View {
    var burger: Burgers
    @ObservedObject var viewModel: MainViewModel
    let content: Content
    
    init(burger: Burgers, viewModel: MainViewModel, content: () -> Content) {
        self.burger = burger
        self.viewModel = viewModel
        self.content = content()
    }
    
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
            
            content
           
            
        }
        
    }
}


