//
//  PaymentView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 24.09.24.
//

import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showSheet: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Spacer()
                        .frame(width: 15)
                    
                    Text("Payment method")
                        .font(.custom("Fira-GO", size: 22))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 25){
                        ForEach(viewModel.cards.dropFirst(), id: \.hashValue) { item in
                            CardTypeList(viewModel: viewModel, item: item)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 4)
                .scrollIndicators(.hidden)
                
                
                ScrollView{
                    
                    Cards(viewModel: viewModel, show: $showSheet, showAlert: $showAlert)
                }
            }
     
        }
        
    }
}

//#Preview {
//    PaymentView(viewModel: MainViewModel())
//}
