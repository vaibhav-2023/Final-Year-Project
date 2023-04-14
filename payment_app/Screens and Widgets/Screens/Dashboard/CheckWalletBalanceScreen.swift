//
//  CheckWalletBalanceScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import SwiftUI

//screen to show wallet balance
struct CheckWalletBalanceScreen: View {
    
    //added on 10/04/23, for handling view model
    @StateObject private var profilevM = ProfileViewModel()
    
    //constants for spacing and padding
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
                Text(currencySymbol + " \(profilevM.userModel?.walletBalance ?? 0.0)")
                    .fontCustom(.Regular, size: 17)
                    .foregroundColor(.darkGrayColor)
            }.padding(padding)
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.walletBalance)
            .showLoader(isPresenting: .constant(profilevM.isAnyApiBeingHit))
            .onAppear {
                profilevM.getProfile()
            }
    }
}

struct CheckWalletBalanceScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckWalletBalanceScreen()
    }
}
