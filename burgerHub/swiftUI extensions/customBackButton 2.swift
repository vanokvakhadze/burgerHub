//
//  customBackButton.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 11.10.24.
//

import SwiftUI

struct customBackButton: View {
   @Binding var path: NavigationPath
    var text: String
    var pathNumber: Int
    
    var body: some View {
        Button(action: {
            path.removeLast(pathNumber)
        }) {
            Image(systemName: "chevron.left") 
                    .foregroundStyle(.black)
                    .padding()
                    .padding(.leading, 5)
                .background(
                    Circle()
                      .fill(Color.init(uiColor: .systemBackground))
                        .frame(width: 35, height: 35)
                )
            Text(text)
                .font(.custom("FiraGO-Regular", size: 22))
                .padding(.leading, 5)
                
        }
        .foregroundStyle(.primary)
        
    }
    
}

