//
//  LocationDetails.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 03.12.24.
//

import SwiftUI
import MapKit

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
//#Preview {
//    LocationDetails()
//}
