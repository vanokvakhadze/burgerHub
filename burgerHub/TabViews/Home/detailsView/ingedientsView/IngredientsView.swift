//
//  IngredientsView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 11.10.24.
//

import SwiftUI

struct IngredientsView: View {
    @Binding var burger: Burgers
    @ObservedObject var viewModel: MainViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack{
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25){
                    Text(burger.name)
                        .font(.title)
                        .padding(.trailing, 15)
                    
                    
                    ForEach(burger.images, id: \.lg) { item in
                        fetchImage(imageURL: item.lg ?? "", width: 230, height: 150)
                            .clipShape(.rect(cornerRadius: 20))
                    }
                    
                    Spacer()
                        .frame(height: 15)
                    
                    HStack{
                        Spacer()
                            .frame(width: 20)
                        Text("Ingredients")
                            .font(.custom("FiraGO-Regular", size: 18))
                            .padding(.trailing, 15)
                        Spacer()
                    }
                    
                    
                    ForEach(burger.ingredients, id: \.id)  {  item in
                        
                        HStack(spacing: 15){
                            Spacer()
                                .frame(width: 10)
                            
                            Text(item.name)
                                .font(.custom("FiraGO-Regular", size: 16))
                                .frame(width: 140, alignment: .leading)
                            
                            fetchImage(imageURL: item.img, width: 45, height: 45)
                            
                            
                            Spacer()
                                .frame(width: 5)
                            
                            
                            
                            sysImage(image: "minus.circle", width: 25, height: 25)
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    viewModel.decreaseIngredients(of: item, in: burger)
                                }
                            
                            if item.amountOf == 0 {
                                Text("-")
                                    .font(.system(size: 18))
                                
                            } else {
                                Text("\(viewModel.getAmountIngredients(of: item, in: burger))")
                                    .font(.system(size: 18))
                            }
                          
                            sysImage(image: "plus.circle", width: 25, height: 25)
                                .foregroundStyle(.green)
                                .onTapGesture {
                                    viewModel.addIngredients(of: item, in: burger)
                                }
                            
                            
                            Spacer()
                                .frame(width: 5)
                            
                            
                        }
                        
                        
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button("Ok", action: {
                        path.removeLast( )
                    })
                    .frame(width: 160, height: 40)
                    .background(.buttonC)
                    .clipShape(.rect(cornerRadius: 20))
                    .foregroundColor(.white)
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: customBackButton(path: $path, text: "Details", pathNumber: 1))
            }
        }
    }
    
}

//struct IngredientsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        // Provide a default path for the prev
//        IngredientsView(ingredients: Burgers(id: 1, name: "Biscuit", images: [ImageSize(sm: "https://s7d1.scene7.com/is/image/mcdonalds/t-mcdonalds-Bacon-Egg-Cheese-Biscuit-Regular-Size-Biscuit-1:1-4-product-tile-desktop", lg: "https://s7d1.scene7.com/is/image/mcdonalds/t-mcdonalds-Egg-McMuffin-1:product-header-mobile?wid=768&hei=443&dpr=off")], desc: "The McDonald\'s Bacon, Egg & Cheese Biscuit breakfast sandwich features a warm, buttermilk biscuit brushed with real butter, thick cut Applewood smoked bacon, a fluffy folded egg, and a slice of melty American cheese. There are 460 calories in a Bacon, Egg & Cheese Biscuit at McDonald\'s.", ingredients: [Ingredients(id: 1, name: "Folded Egg", img: "https://s7d1.scene7.com/is/image/mcdonalds/biscuit"), Ingredients(id: 2, name: "Biscuit", img: "https://s7d1.scene7.com/is/image/mcdonalds/folded_egg"), Ingredients(id: 3, name: "Pasteurized Process American Cheese", img: "https://s7d1.scene7.com/is/image/mcdonalds/ingredient_american_cheese_180x180"),  Ingredients(id: 4, name: "Salted Butter", img: "https://s7d1.scene7.com/is/image/mcdonalds/applewood_bacon"),  Ingredients(id: 5, name: "Pasteurized Process American Cheese", img: "https://s7d1.scene7.com/is/image/mcdonalds/butter_salted"), Ingredients(id: 6, name:"clarified_butter", img:  "https://s7d1.scene7.com/is/image/mcdonalds/clarified_butter"),    ], price: 3.4, veg: false), path: .constant(NavigationPath()))
//        
//    }
//}

