//
//  PaymentResultView .swift
//  burgerHub
//
//  Created by vano Kvakhadze on 05.11.24.
//

import SwiftUI

struct PaymentResultView_: View {
   // @Binding var path: NavigationPath
    @State var isAnimated = false
    
    var body: some View {
        ZStack (alignment: .bottom) {
            
            VStack(spacing: 20){
                
                sysImage(image: "checkmark.circle",
                         width: isAnimated ?  260 : 50,
                         height: isAnimated ?  180 : 30)
                .offset(y: isAnimated ? 30 : 300)
                
                .foregroundStyle(.green)
                .background(
                    RoundedRectangle(cornerRadius: isAnimated ? 30 : 15)
                        .fill(Color.init(uiColor: .secondarySystemBackground))
                        .frame(width: isAnimated ?  320 : 70,
                               height: isAnimated ?  300 : 70)
                        .shadow(color: .green, radius: 1)
                        .rotationEffect(Angle(degrees: isAnimated ? 90 : 0 ))
                        .offset(y: isAnimated ? 130 : 300)
                    
                )
                
                Spacer()
                    .frame(height: 110)
                
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
                
                
                    
                
                ZStack (alignment: .bottom) {
                    Button("Go To Home ", action: {
                        // path.removeLast(4)
                    })
                    .frame(width: 330, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.buttonC)
                    )
                    .foregroundStyle(.white)
                    
                   
                    
                }
               
                
                
            }
        
        }
        
    }
}

#Preview {
    PaymentResultView_()
}
