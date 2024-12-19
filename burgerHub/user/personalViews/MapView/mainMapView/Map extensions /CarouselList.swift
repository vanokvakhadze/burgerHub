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
                        .frame(width: size.width - 20, height: size.height - 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top, 10)
                    
                    
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
                        
                        Text(card.adress)
                            .font(.custom("FiraGO", size: 18))
                            .fontWeight(.regular)
                        
                        Spacer()
                        
                        
                        
                    }
                    .padding(.bottom, 10)
                    
                    
                    
                }
                .frame(width: size.width)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .gray, radius: 8)
                
                ZStack{
                    Button(action: {
                        viewModel.calculateRouteDetails(to: viewModel.mapLocation)
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
                 //   .simultaneousGesture(DragGesture(), including: .subviews)
                    
                   
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
