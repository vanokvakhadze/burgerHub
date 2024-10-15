//
//  sysImage.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 10.10.24.
//

import SwiftUI

struct sysImage: View {
    var image: String
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        Image(systemName: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
    }
}


