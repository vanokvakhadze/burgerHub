//
//  HelpView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 24.09.24.
//

import SwiftUI
import MapKit
import CoreLocation



struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    @Namespace private var scope
    
    
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            Map(position: $viewModel.cameraPosition, scope: scope) {
                
                Annotation("", coordinate: viewModel.userLocation) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }.annotationTitles(.hidden)
                
                
                
                ForEach(viewModel.locations) { location in
                    Annotation("", coordinate: location.coordinates) {
                        BurgerLocation(location: location)
                            .scaleEffect(viewModel.mapLocation == location ? 1 : 0.7)
                            .onTapGesture {
                                viewModel.tapToNextLocation(location: location)
                            }
                    }
                    
                    //   UserAnnotation()
                    
                    
                }
                
            }
            
            .ignoresSafeArea()
            .onAppear{
                viewModel.locationManager.requestWhenInUseAuthorization()
            }
            
            .overlay(alignment: .topTrailing ){
                VStack(spacing: 15) {
                    MapUserLocationButton(scope: scope)
                    MapPitchToggle(scope: scope)
                    MapCompass(scope: scope)
                }
                .buttonBorderShape(.circle)
                .padding()
            }
            .mapScope(scope)
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            
            
            ZStack {
                VStack{
                    LocationDetails(spacing: 30, index: $viewModel.currentIndex, items: viewModel.locations, viewModel: viewModel) { card in
                        
                        CarouselList(viewModel: viewModel, card: card)
                        
                        
                    }
                    
                    indicators(viewModel: viewModel)
                        .padding(.top, 5)
                }
                .padding(.vertical, 30)
                
            }
            
            .frame(maxWidth: .infinity)
            .frame( height: viewModel.activeRoute ? 140 : 320 )
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, -35)
            
            
        }
    }
    
    func BurgerLocation(location: Location) -> some View{
        ZStack{
            Image(uiImage: .burgerlogo)
                .resizable()
                .scaledToFill()
                .frame(width: 38, height: 38)
                .clipShape(Circle())
                .background(
                    Circle()
                        .fill(Color.orange.opacity(viewModel.mapLocation == location ? 1 : 0.1))
                        .frame(width: 45, height: 45)
                )
            
        }
    }
    
    func indicators(viewModel: MapViewModel) -> some View {
        HStack{
            ForEach(viewModel.locations.indices) {  index in
                Circle()
                    .fill(Color.orange.opacity(viewModel.currentIndex == index ? 1 : 0.1))
                    .frame(width: 10, height: 10)
                    .scaleEffect(viewModel.currentIndex == index ? 1.4 : 1)
                    .animation(.spring, value: viewModel.currentIndex == index)
                    .onTapGesture {
                        viewModel.tapToNextLocation(location: viewModel.locations[index])
                    }
                
                
            }
        }
    }
    
}



#Preview{
    if #available(iOS 18.0, *) {
        MapView()
    } else {
        // Fallback on earlier versions
    }
}











