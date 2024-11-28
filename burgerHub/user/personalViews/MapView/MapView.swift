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
        
        ZStack(alignment: .bottom){
            
            Map(position: $viewModel.cameraPosition) {
                ForEach(viewModel.locations) { location in
                    Annotation(" ", coordinate: location.coordinates) {
                        BurgerLocation(location: location)
                            .scaleEffect(viewModel.mapLocation == location ? 1 : 0.7)
                            .onTapGesture {
                                viewModel.tapToNextLocation(location: location)
                            }
                    }
                }
                
            }
           
            .ignoresSafeArea()
            
            .mapControls{
                MapCompass()
                MapPitchToggle()
                
            }
            ZStack {
                VStack{
                    LocationDetails(index: $viewModel.currentIndex, items: viewModel.locations) { card in
                        
                        GeometryReader { proxy in
                            let size = proxy.size
                            VStack{
                                HStack{
                                    Image(uiImage: UIImage(named: card.image) ?? .burgerlogo)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    
                                    Text(card.cityName)
                                }
                                
                            }
                            .frame(width: size.width)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        }
                    }
                    
                    HStack{
                        ForEach(viewModel.locations.indices) {  index in
                            Circle()
                                .fill(Color.blue.opacity(viewModel.currentIndex == index ? 1 : 0.1))
                                .frame(width: 10, height: 10)
                                .scaleEffect(viewModel.currentIndex == index ? 1.4 : 1)
                                .animation(.spring, value: viewModel.currentIndex == index )
                            
                            
                        }
                    }
                }
                .padding(.vertical, 30)
                
                
            }
          
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, -30)
            .onTapGesture{
                viewModel.swipeAction()
            }
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
 
}



#Preview{
    MapView()
}



struct LocationDetails<Content: View, T: Identifiable>: View {
    var list: [T]
    var content: (T) -> Content
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    @GestureState var offset: CGFloat = 0
    
    
    init( spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    
    var body: some View {

            GeometryReader { proxy in
                let width = proxy.size.width - (trailingSpace  - spacing)
                let adjustMentWidth = (trailingSpace / 2) - spacing
                
                HStack(spacing: spacing){
                    ForEach(list) { item in
                        content(item)
                            .frame(width: proxy.size.width - trailingSpace)
                    }
                }
                .padding(.horizontal, spacing)
                .offset(x: (CGFloat(index) * -width) + ( index != 0 ? adjustMentWidth : 0) + offset)
                .gesture(
                    DragGesture()
                        .updating($offset, body: { value, out, _ in
                            out = value.translation.width
                        })
                        .onEnded({ value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            let roundedIndex = progress.rounded()
                            
                            index =  max(min(index + Int((roundedIndex)), list.count - 1), 0)
                           
                        })
                        
                )
                
            }
            .animation(.easeInOut, value: offset == 0)
    }
}
