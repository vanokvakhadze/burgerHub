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
  
    var body: some View {
        VStack{
            Map(position: $viewModel.cameraPosition){
                
                UserAnnotation()
            }
            .onAppear{
                viewModel.checkIfLocationManagerEnabled()
            }
        }
       // .ignore
    }
}


#Preview{
    MapView()
}
