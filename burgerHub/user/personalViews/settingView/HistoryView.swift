//
//  HistoryView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 24.09.24.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: MainViewModel
   
    
    var body: some View {
        ZStack{
            Color.init(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                        .frame(width: 15)
                    
                    Text("History")
                        .font(.custom("Fira-GO", size: 22))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.vertical, 15)
                
                ScrollView{
                    ForEach(viewModel.burgers.indices, id: \.self ) {
                        
                        index in
                        let burger = viewModel.burgers[index]
                       
        
                    
                        SearchList(burger: burger, viewModel: viewModel) {
                            ZStack {
                                
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(viewModel.colorOfBoughtBurgers(index: index)))
                                    .frame(width: 25)
                                
                                Rectangle()
                                    .fill(.background)
                                    .frame(width: 12)
                                    .padding(.leading, -15)
                                
                            }
                            
                            
                        }
                    }
                }
                
            }
        }
        .onAppear{
            viewModel.fetchData()
        }
        
    }
}

//#Preview {
//    HistoryView(viewModel: MainViewModel())
//}
