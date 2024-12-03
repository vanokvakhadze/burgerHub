//
//  DirectioView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 03.12.24.
//

import SwiftUI
import MapKit

struct DirectionView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        HStack{
            Spacer()
                .frame(width: 20)
            if let route = viewModel.route{
            
                VStack(spacing: 10){
                    Text(" \(String(format: "%.2f", route.distance / 1000)) ")
                        .font(.custom("FiraGO", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    
                    
                    Text("\(Int(route.expectedTravelTime / 60)) ")
                        .font(.custom("FiraGO", size: 18))
                        .fontWeight(.regular)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.cancelRoute()
            }){
                Text("Exit")
                    .font(.custom("FiraGO", size: 22))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 100, height: 60)
                            .foregroundStyle(.red)
                    )
            }
            
            
            Spacer()
                .frame(width: 55)
        }

    }
}

//#Preview {
//    DirectioView()
//}
