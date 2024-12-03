//
//  HelpView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 24.09.24.
//

import SwiftUI
import MapKit




struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    @Namespace private var scope
    
    
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            Map(position: $viewModel.cameraPosition,  scope: scope) {
                if let userLocation = viewModel.userLocation {
                    Annotation("User Location", coordinate: userLocation) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }.annotationTitles(.hidden)
                }
               
                
                ForEach(viewModel.sortedLocations) { location in
                    Annotation(" ", coordinate: location.coordinates) {
                        BurgerLocation(location: location)
                            .scaleEffect(viewModel.mapLocation == location ? 1 : 0.7)
                            .onTapGesture {
                                viewModel.tapToNextLocation(location: location)
                            }
                    }.annotationTitles(.hidden)
                }
                
                if let route = viewModel.route {
                                    MapPolyline(route.polyline)
                                        .stroke(Color.blue, lineWidth: 5)
                                }
                
            }
            
            .ignoresSafeArea()
            .onAppear{
                viewModel.requestLocationAccess()
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
                if viewModel.activeRoute {
                    DirectionView(viewModel: viewModel)
                    
                } else {
                    VStack{
                        LocationDetails(spacing: 30, index: $viewModel.currentIndex, items: viewModel.sortedLocations) { card in
                            
                            CarouselList(viewModel: viewModel, card: card)
                                
                        }
//
                        
                        
                        indicators(viewModel: viewModel)
                            .padding(.top, 5)
                    }
                    .padding(.vertical, 30)
                    
                }
                
            }
            
            .frame(maxWidth: .infinity)
            .frame( height: viewModel.activeRoute ? 140 : 320 )
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, -35)
//            .onTapGesture{
//                viewModel.swipeAction()
//            }
            
           
        }
    }
    
    func BurgerLocation(location: Location) -> some View{
        ZStack{
            Image(uiImage: UIImage(named: location.image) ?? .burgerlogo)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
        }
    }
    
    func indicators(viewModel: MapViewModel) -> some View {
        HStack{
            ForEach(viewModel.sortedLocations.indices) {  index in
                Circle()
                    .fill(Color.blue.opacity(viewModel.currentIndex == index ? 1 : 0.1))
                    .frame(width: 10, height: 10)
                    .scaleEffect(viewModel.currentIndex == index ? 1.4 : 1)
                    .animation(.spring, value: viewModel.currentIndex == index )
                    .onTapGesture {
                        viewModel.currentIndex = index
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











