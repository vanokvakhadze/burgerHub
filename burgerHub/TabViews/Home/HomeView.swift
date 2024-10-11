//
//  HomeView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI

struct HomeView: View {
    @Binding var isShown: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                    .frame(width: 20)
                Button{
                    withAnimation{isShown.toggle()}
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                        
                }
                .frame(width: 40, height: 40)
                .background(Color.init(uiColor: .secondarySystemBackground))
                .cornerRadius(15)
                
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView(isShown: .constant(false))
}
