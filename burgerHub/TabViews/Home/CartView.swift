//
//  CartView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 15.10.24.
//

import SwiftUI

struct CartView: View {
   
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: CachingService
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    HStack{
                        Spacer()
                            .frame(width: 20)
                        Text("Your Cart")
                            .font(.custom("FiraGO-Regular", size: 20))
                        
                        Spacer()
                    }
                    
                    ForEach(viewModel.burgers ) { item in
                        HStack{
                            Spacer()
                                .frame(width: 10)
                            ForEach(item.images,id: \.lg){ img in
                                fetchImage(imageURL: img.lg ?? "", width: 78, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                          
                            VStack (spacing: 20){
                                HStack{
                                    Spacer()
                                        .frame(width: 20)
                                    Text(item.name)
                                        .lineLimit(3)
                                    Spacer()
                                }
                                .padding(.top, -10)
                                
                                HStack{
                                    Spacer()
                                        .frame(width: 25)
                                  
                                        .foregroundStyle(.green)
                                    Text("$ \(String(format: "%.1f", item.price))")
                                    
                                    Spacer()
                                }
                                
                            }
                            
                            ZStack{
                                HStack{
                                    sysImage(image: "minus.circle", width: 22, height: 22)
                                        .foregroundStyle(.white)
                                        .background(
                                            Circle()
                                                .fill(.buttonC)
                                        )
                                    
                                    
                                    Text("1")
                                        .font(.system(size: 18))
                                       
                                  
                                    sysImage(image: "plus.circle", width: 22, height: 22)
                                        .foregroundStyle(.white)
                                        .background(
                                            Circle()
                                                .fill(.buttonC)
                                            )
                                        
                                }
                                
                            }
                            .padding(.top, 30)
                            
                            
                            Spacer()
                        }
                        .frame(width: 335, height: 120)
                        .background(Color.init(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.vertical, 10)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                    
                    HStack{
                        Spacer()
                            .frame(width: 15)
                        
                        Text("Total")
                        
                        Spacer()
                        
                        Text("$335")
                        
                        Spacer()
                            .frame(width: 20)
                        
                    }
                    .frame(width: 330, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: .systemBackground))
                    )
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button("Process to payment", action: {
                        
                    })
                    .frame(width: 335, height: 50)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.buttonC)
                        
                    )
                }
                
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: customBackButton(path: $path, text: "Detials"))
            
            .onAppear{
                viewModel.fetchData()
            }
        }
    }
}
struct CartView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CartView( path: .constant(NavigationPath()), viewModel: CachingService())
        
    }
}
