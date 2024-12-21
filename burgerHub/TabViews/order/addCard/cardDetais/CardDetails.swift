//
//  CardDetails.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 25.10.24.
//

import SwiftUI

struct CardDetails: View {
    
    @FocusState private var activeTF: CardTypes!
    @State private var cardNumber: String = ""
    @State private var cardHolderName: String = ""
    @State private var cardExDate: String = ""
    @State private var cardCvv: String = ""
    var cardType: String 
    @ObservedObject var viewModel: MainViewModel
    @Binding var show: Bool
    @State var isScanning: Bool = false
    
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                Spacer()
                    .frame(width: 15)
                Image(systemName: "viewfinder.rectangular")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                   
                    .background(
                        Circle()
                            .fill(Color.init(.secondarySystemBackground))
                            .frame(width: 45, height: 45)
                    )
                    .onTapGesture {
                        isScanning.toggle()
                    }
                    .sheet(isPresented: $isScanning, content: {
                        ScanningCard(cardNumber: $cardNumber, expiryDate: $cardExDate, cardHolder: $cardHolderName, cvv: $cardCvv) {
                            isScanning = false
                        }
                        
                    })
                
                Spacer()
            }
            
            cardDetails()
            
            Spacer()
                .frame(height: 50)
            Button("Add Card  ", action: {
               
                let cardInfo: [String: String] = [
                                   "number": cardNumber,
                                   "holderName": cardHolderName,
                                   "exDate": cardExDate,
                                   "cvv": cardCvv,
                                   "cardType": cardType
                               ]
                DispatchQueue.main.async {
                    
                    viewModel.addNewCard(cardDetails: cardInfo)
                    
                    show = false
                }
              
            })
            .frame(width: 300, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.buttonC)
            )
            .tint(.white)
        }
        .padding()
    }
    
    @ViewBuilder
    func cardDetails() -> some View  {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.brown)
            
            VStack(spacing: 10){
                HStack{
                    
                    TextField("Card Holder Name", text: $cardHolderName)
                        .onChange(of: cardHolderName) {
                            cardHolderName = String(cardHolderName.prefix(20))
                        }
                        .focused($activeTF, equals: .cardHolderName)
                    
                    Spacer(minLength: 0)
                    
                    ZStack(alignment: .trailing){
                        
                        Image(cardType)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    }
                    .padding(.bottom, -35)
                    
                }
                
              
                
                HStack{
                    TextField("XXXX XXXX XXXX XXXX", text: $cardNumber )
                        .onChange(of: cardNumber) { value, x in
                            
                            cardNumber = value
                                 .filter { $0.isNumber }
                                 .prefix(16)
                                 .enumerated()
                                 .map { index, char in (index % 4 == 0 && index > 0) ? " \(char)" : String(char) }
                                 .joined()
                        
                    }
                        .font(.title3)
                        .keyboardType(.numberPad)
                        .focused($activeTF , equals: .cardNumber)
                    
                    Spacer(minLength: 0)
                    
                
                }
                .padding(.top, 10)
                
                
              
                
                HStack(spacing: 12){
                    TextField("MM/YY", text: $cardExDate)
                        .onChange(of: cardExDate) {
                       
                        let value = cardExDate
                        if value.count == 3 && !value.contains("/"){
                            let startIndex = value.startIndex
                            let thirdPosition = value.index(startIndex, offsetBy: 2)
                            cardExDate.insert("/", at: thirdPosition)
                            
                        }
                        
                        if value.last == "/" {
                            cardExDate.removeLast()
                        }
                        
                        cardExDate = String(cardExDate.prefix(5))
                        
                    }
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .expirationDate)
                    
                    Spacer(minLength: 0)
                    
                    TextField("CVV", text: $cardCvv)
                        .onChange(of: cardCvv, {
                            cardCvv = String(cardCvv.prefix(3))
                        })
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .cvv)
                    
                }
                .padding(.top, 25)
                .padding(.horizontal, 10)
                
                
              
             
            }
            .padding(20)
            .environment(\.colorScheme, .dark)
            .tint(.white)
        }
        .frame(height: 200)
   
    }
}

//#Preview {
//   // CardDetails(cardType: "Visa", viewModel: MainViewModel(), show: true)
//}
