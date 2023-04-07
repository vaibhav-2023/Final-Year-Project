//
//  CheckWalletBalanceScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import SwiftUI

//screen to show wallet balance
struct CheckWalletBalanceScreen: View {
    
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: spacing) {
                HStack {
                    Text(AppTexts.walletBalance)
                        .fontCustom(.Medium, size: 28)
                    
                    Spacer()
                }
                
                let currencySymbol = Singleton.sharedInstance.generalFunctions.getCurrencySymbol()
                Text(currencySymbol + " ")
            }.padding(padding)
        }.setNavigationBarTitle(title: AppTexts.walletBalance)
            //.showLoader(isPresenting: <#T##Binding<Bool>#>)
    }
}

struct CheckWalletBalanceScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckWalletBalanceScreen()
    }
}
