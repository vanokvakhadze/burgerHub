//
//  PaymentResultView .swift
//  burgerHub
//
//  Created by vano Kvakhadze on 05.11.24.
//

import SwiftUI

struct PaymentResultView: View {
    @Binding var path: NavigationPath
    @State var isAnimated: Bool = false
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                VStack(spacing: 20){
                    
                    sysImage(image: "checkmark.circle",
                             width: isAnimated ?  260 : 50,
                             height: isAnimated ?  180 : 30)
                    .animation(.easeIn(duration: 0.5), value: isAnimated)
                    
                    .foregroundStyle(.green)
                    .background(
                        RoundedRectangle(cornerRadius: isAnimated ? 30 : 15)
                            .fill(Color.init(uiColor: .systemBackground))
                            .frame(width: isAnimated ?  320 : 70,
                                   height: isAnimated ?  300 : 70)
                            .shadow(color: .green, radius: 1)
                            .rotationEffect(Angle(degrees: isAnimated ? 90 : 0 ))
                            .animation(.easeIn(duration: 0.5), value: isAnimated)
                        
                    )
                    
                    Spacer()
                        .frame(height: 80)
                    
                    Text( isAnimated ?  "Congratulations!" : "")
                        .font(.custom("Sen", size: 24))
                        .fontWeight(.bold)
                        .opacity(isAnimated ? 1 : 0)
                        .scaleEffect(isAnimated ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.5), value: isAnimated)
                    
                    
                    
                    Text(isAnimated ? "You successfully maked a payment, enjoy our service!" : "")
                        .font(.custom("Sen", size: 14))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .opacity(isAnimated ? 1 : 0)
                        .scaleEffect(isAnimated ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.5), value: isAnimated)
                        .frame(width: 240)
                    
                    
                    
                }
                
                Spacer()
                    .frame(height: 40)
                
                Button("Go To Home ", action: {
                    path.removeLast(3)
                })
                .frame(width: 330, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.buttonC)
                )
                .foregroundStyle(.white)
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: customBackButton(path: $path, text: "Orders", pathNumber: 1))
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
        
    }
}


struct PaymentResultView_Previews: PreviewProvider {
    static var previews: some View {
        @State var samplePath = NavigationPath()
        @State var animated = true
        PaymentResultView(path: $samplePath)
    }
}
