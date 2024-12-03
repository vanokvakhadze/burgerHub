//
//  CarouselList.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 03.12.24.
//

import SwiftUI
import MapKit

struct CarouselList: View {
    @ObservedObject var viewModel: MapViewModel
    var card: Location
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .bottomTrailing){
                VStack(spacing: 10){
                    
                    Image(uiImage: UIImage(named: card.image) ?? .burgerlogo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height - 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    
                    HStack{
                        Spacer()
                            .frame(width: 15)
                        
                        Text(card.cityName)
                            .font(.custom("FiraGO", size: 22))
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    HStack{
                        Spacer()
                            .frame(width: 10)
                        
                        Text(card.name)
                            .font(.custom("FiraGO", size: 18))
                            .fontWeight(.regular)
                        
                        Spacer()
                        
                        
                        
                    }
                    .padding(.bottom, 5)
                    
                    
                    
                }
                .frame(width: size.width)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .gray, radius: 8)
                
                ZStack{
                    Button(action: {
                        viewModel.calculateRouteDetails(to: card)
                        print("click")
                        
                    }) {
                        sysImage(image: "location.north.fill", width: 16, height: 16)
                            .foregroundStyle(.green)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 35, height: 35)
                                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                    .shadow(color: .green, radius: 2)
                            )
                    }
                    
                   
                }
                .padding(.bottom, 18)
                .padding(.trailing, 20)
                
                
            }
        }
    }
}

//#Preview {
//    CarouselList()
//}
