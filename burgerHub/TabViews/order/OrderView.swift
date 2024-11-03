//
//  OrderView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 23.09.24.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showSheet: Bool = false
    @State var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    
    var body: some View {
        //  ScrollView {
        VStack (spacing: 20){
            ScrollView(.horizontal) {
                HStack(spacing: 16){
                    ForEach(viewModel.cards, id: \.hashValue) { item in
                        CardTypeList(viewModel: viewModel, item: item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 4)
            .scrollIndicators(.hidden)
            
            
            Cards(viewModel: viewModel, show: $showSheet, showAlert: $showAlert, selected: viewModel.selectedCardType ?? "")
                .padding(.bottom, 20)
            
            
            
            HStack{
                Spacer()
                    .frame(width: 24)
                
                Text("TOTAL")
                    .font(.custom("Sen", size: 22))
                    .foregroundStyle(.gray)
                
                Text("$\(String(format: "%.1f", viewModel.totalPrise))")
                    .font(.custom("Sen", size: 30))
                
                Spacer()
            }
            Spacer()
                .frame(height: 14)
            
            
            if viewModel.tappedCard != nil || viewModel.selectedCardType == "Cash" {
                Button( action: {
                    
                }) {
                    Text("Pay & Confirm")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .frame(width: 327, height: 62)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.buttonC)
                )
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: customBackButton(path: $path, text: "Cart", pathNumber: 3))
        .onAppear{
            viewModel.loadCards()
        }
    }
    
    
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample NavigationPath for preview
        @State var samplePath = NavigationPath()
        
        OrderView(viewModel: MainViewModel(), path: $samplePath)
    }
}


struct Cards: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var show: Bool
    @Binding var showAlert: Bool
    var selected: String
    
    var body: some View {
        
        ScrollView{
            
            if viewModel.creditCard.isEmpty {
                VStack{
                    Image(uiImage: .card)
                        .resizable()
                        .frame(width: 170, height: 110)
                    
                    Text("No master card added")
                        .bold()
                        .font(.custom("Sen", size: 16))
                        .padding(.top, 13)
                    
                    
                    Text("You can add a mastercard and save it for later")
                        .frame(width: 230,  height: 55)
                        .fontWeight(.regular)
                        .font(.custom("Sen", size: 15))
                        .foregroundStyle(Color.init(uiColor: .systemGray))
                        .multilineTextAlignment(.center)
                    
                }
                .frame(width: 327, height: 257)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.init(uiColor: .secondarySystemBackground))
                )
                
            } else {
                NavigationView{
                    List{
                        ForEach(viewModel.filteredCreditCards.keys.sorted(), id: \.self) { key in
                            if let card = viewModel.filteredCreditCards[key] {
                                
                                HStack(alignment: .center) {
                                    VStack(spacing: 10){
                                        
                                        HStack{
                                            
                                            Text("\(card["cardType"] ?? "")")
                                                .bold()
                                            
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Image(card["cardType"] ?? "")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 25, height: 25)
                                            
                                            
                                            Text(viewModel.maskedCardNumber(card["number"] ?? ""))
                                            
                                            Spacer()
                                        }
                                        
                                    }
                                    Spacer()
                                    
                                    Image(systemName: viewModel.tappedCard == key ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle( viewModel.tappedCard == key ?  .green : .gray )
                                        .onTapGesture {
                                            viewModel.tappedCard = key
                                        }
                                    
                                }
                                .padding(.horizontal, 15)
                                .frame(height: 87)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.systemGroupedBackground))
                                )
                            }
                            
                        }
                        .onDelete(perform: deleteCard)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 25))
                        .listRowBackground(Color(uiColor: .systemBackground))
                        
                        
                    }
                    .padding(.top, 15)
                    .listRowSeparator(.hidden)
                    
                    
                    
                    .scrollIndicators(.hidden)
                    .listStyle(PlainListStyle())
                }
                
            }
            
            HStack{
                Spacer()
                Button(action: {
                    
                    show.toggle()
                    
                }) {
                    HStack{
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.buttonC)
                        
                        Text("ADD TO NEW")
                            .fontWeight(.bold)
                            .foregroundStyle(.buttonC)
                        
                    }
                }
                
                .frame(width:307 ,height: 62)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke( Color(uiColor: .secondarySystemBackground) ,lineWidth: 3)
                )
                .sheet(isPresented: $show, content: {
                    
                    CardDetails(cardType: selected, viewModel: viewModel, show: $show)
                        .presentationDetents([.medium])
                    
                })
                .alert("Please select a card type", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                Spacer()
                
                
            }
            
        }
    }
    
    private func deleteCard(at offsets: IndexSet) {
        offsets.forEach { index in
            let cardKey = Array(viewModel.creditCard.keys.sorted())[index]
            viewModel.deleteCard(uniqueKey: cardKey)
        }
    }
}

struct CardTypeList: View {
    @ObservedObject var viewModel: MainViewModel
    var item: String
    
    var body: some View {
        VStack{
            ZStack{
                Image(item)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                
            }
            .frame(width: 85, height: 72)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill( viewModel.selectedCardType != item ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground))
            )
            .overlay(
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.selectedCardType == item ? Color.buttonC : Color.clear, lineWidth: 3)
                    
                    if viewModel.selectedCardType == item {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.buttonC)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 27, height: 27)
                            )
                            .frame(width: 24, height: 24)
                            .offset(x: 30, y: -30)
                    }
                }
                
            )
            
            Text(item)
                .font(.custom("Sen", size: 14))
            
            
            
        }
        
        .frame(width: 85, height: 93)
        .onTapGesture {
            
            viewModel.selectedCardType = item
        }
    }
}



