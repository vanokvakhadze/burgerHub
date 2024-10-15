//
//  BurgerList.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 10.10.24.
//

import SwiftUI

struct BurgerList: View {
    var burger: Burgers
    
    var body: some View {
        VStack{
            
            ForEach(burger.images, id: \.sm) { img in
                fetchImage(imageURL: img.lg ?? "" , width: 120, height: 60)
                    .padding(.top, 5)
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
                .frame(height: 20)
            
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
            
            ZStack{
                sysImage(image: "plus", width: 17, height: 17)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                                .frame(width: 23, height: 23)
                                .foregroundStyle(.buttonC)
                    )
                    
            }
            .padding(.top, -35)
            .padding(.leading, 90)
        }
        .background(Color.init(uiColor: .systemBackground))
        .clipShape(.rect(cornerRadius: 20))
        
    }
  
}


