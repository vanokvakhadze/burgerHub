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
                .padding(.bottom, 40)
                
                
                
                Cards(viewModel: viewModel, show: $showSheet, showAlert: $showAlert, selected: viewModel.selectedCardType ?? "")
            }
         
     
        }
        
    }
}

#Preview {
    PaymentView(viewModel: MainViewModel())
}
