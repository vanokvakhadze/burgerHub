//
//  DetailsView.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 10.10.24.
//

import SwiftUI

struct DetailsView: View {
    @Binding var burger: Burgers
    @ObservedObject var viewModel: MainViewModel
    @Binding var path: NavigationPath
    @Binding var tabBarHide: Bool
    @Binding var activeTab: Tab
    
    var body: some View {
      
        ZStack(alignment: .topTrailing){
            Color(uiColor: UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView{
                
                VStack(spacing: 35){
                    headerImages(burger: burger, path: $path)
                    
                    HStack(spacing: 17){
                        if burger.amount > 1 {
                            sysImage(image: "minus.circle", width: 20, height: 20)
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    viewModel.decreaseBurger(of: burger)
                                    
                                }
                            
                        }else {
                            Spacer()
                                .frame(width: 20)
                        }
                        
                        Text("\(viewModel.getAmount(of: burger))")
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                        
                        sysImage(image: "plus.circle", width: 20, height: 20)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                viewModel.addBurger(of: burger)
                         
                            }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.buttonC)
                            .frame(width: 110, height: 50)
                    )
                    
                    Text(burger.name)
                        .font(.headline)
                    
                    
                    Text(burger.desc)
                        .padding(.horizontal, 20)
                        .font(.custom("FiraGO-Regular", size: 14))
                    
                    HStack{
                        Spacer()
                            .frame(width: 20)
                        Text("Ingredients")
                            .font(.system(size: 16))
                        Spacer()
                    }
                    
                    getIngredients(burger: burger)
                    
                    Button(action: {

                        path.append(Destinations.ingredients(burger))
                    }) {
                        Text("Change Ingredients")
                            .font(.custom("FiraGO-Regular", size: 18))
                            .padding()
                            .foregroundColor(Color(uiColor: .systemBackground))
                    }
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    
                    
                    Button(action: {
                       
                            viewModel.navigateToCart(burger: burger)
                            activeTab = .basket
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            path.removeLast()
                        }
                        
                        
                    }) {
                        Text("Add to cart ")
                            .font(.custom("FiraGO-Regular", size: 18))
                            .foregroundColor(Color.init(uiColor: .systemBackground))
                    }
                    .frame(width: 355, height: 50)
                    .background(.buttonC)
                    .clipShape(.rect(cornerRadius: 30))
                    
                    
                }
                
                
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled(true)
            
        }
        .onAppear {
            tabBarHide = true
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton(path: $path, text: "Home", pathNumber: 1))
        .navigationDestination(for: Destinations.self) { destination in
            switch destination {
            case .ingredients(_):
                IngredientsView(burger: $burger, viewModel: viewModel, path: $path)
            }
        }
       
    }
    
    
    
    func getIngredients(burger: Burgers) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 25){
                ForEach(burger.ingredients, id: \.id ){ item in
                    HStack{
                        fetchImage(imageURL: item.img, width: 27, height: 27)
                            .padding(.leading, 15)
                        
                        Text(item.name)
                            .font(.custom("FiraGO-Regular", size: 14))
                            .padding(.trailing, 15)
                    }
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color(uiColor: .systemBackground))
                        
                        
                    )
                    .padding(1)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.buttonC)
                        
                    )
                    
                }
                
            }
            
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 15)
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Provide a default path for the prev
//        DetailsView(burger: Burgers(id: 1, name: "Biscuit", images: [ImageSize(sm: "https://s7d1.scene7.com/is/image/mcdonalds/t-mcdonalds-Bacon-Egg-Cheese-Biscuit-Regular-Size-Biscuit-1:1-4-product-tile-desktop", lg: "https://s7d1.scene7.com/is/image/mcdonalds/t-mcdonalds-Egg-McMuffin-1:product-header-mobile?wid=768&hei=443&dpr=off")], desc: "The McDonald\'s Bacon, Egg & Cheese Biscuit breakfast sandwich features a warm, buttermilk biscuit brushed with real butter, thick cut Applewood smoked bacon, a fluffy folded egg, and a slice of melty American cheese. There are 460 calories in a Bacon, Egg & Cheese Biscuit at McDonald\'s.", ingredients: [Ingredients(id: 1, name: "Folded Egg", img: "https://s7d1.scene7.com/is/image/mcdonalds/biscuit"), Ingredients(id: 2, name: "Biscuit", img: "https://s7d1.scene7.com/is/image/mcdonalds/folded_egg"), Ingredients(id: 3, name: "Pasteurized Process American Cheese", img: "https://s7d1.scene7.com/is/image/mcdonalds/ingredient_american_cheese_180x180"),  Ingredients(id: 4, name: "Salted Butter", img: "https://s7d1.scene7.com/is/image/mcdonalds/applewood_bacon"),  Ingredients(id: 5, name: "Pasteurized Process American Cheese", img: "https://s7d1.scene7.com/is/image/mcdonalds/butter_salted"), Ingredients(id: 6, name:"clarified_butter", img:  "https://s7d1.scene7.com/is/image/mcdonalds/clarified_butter"),    ], price: 3.4, veg: false), viewModel: MainViewModel(), path: .constant(NavigationPath()))
//        
//    }
//}


struct headerImages: View {
    var burger: Burgers
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            ForEach(burger.images, id: \.lg) { img in
                
                fetchImage(imageURL: img.lg ?? "", width: 230, height: 200)
                    .clipShape(.rect(cornerRadius: 20))
            }
            ZStack{
                Button(action: {
                    path.append(Destinations.ingredients(burger))
                    }){
                    sysImage(image: "highlighter", width: 20, height: 20)
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.init(uiColor: .systemBackground))
                                .frame(width: 32, height: 32, alignment: .center)
                        )
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(.green)
                                .frame(width: 36, height: 36, alignment: .center)
                        )
                    
                }
                .padding(.top, -8)
                .padding(.leading, 10)
            }
        }
        .padding(.top, 20)
    }
}



enum Destinations: Hashable {
    
    case ingredients(Burgers)
    
}
