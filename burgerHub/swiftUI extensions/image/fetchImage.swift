//
//  fetchImage.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 10.10.24.
//

import SwiftUI

struct fetchImage: View {
    var imageURL: String
    var width: CGFloat
    var height: CGFloat
 
    
    var body: some View {
        ZStack(alignment: .top){
            if let imageURL = URL(string: imageURL) {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                          
                    }
                }
                
            } 
        }
    }
}


