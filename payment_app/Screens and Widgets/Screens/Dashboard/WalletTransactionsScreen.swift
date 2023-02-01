//
//  WalletTransactionsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct WalletTransactionsScreen: View {
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            walletTransaction(walletTransaction: "TEst")
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.walletTransactions)
    }
    
    @ViewBuilder
    private func walletTransaction(walletTransaction: String) -> some View {
        let size = DeviceDimensions.width * 0.12
        let isCredit = true
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                AvatarView(character: String(walletTransaction.capitalized.first ?? " "), size: size)
        
                VStack(spacing: 2) {
                    HStack(spacing: spacing) {
                        Text(walletTransaction)
                            .fontCustom(.Medium, size: 16)
                            .foregroundColor(.blackColor)
                        
                        Spacer()
                        
                        
                        Text((isCredit ? "+" : "-") + " " + "₹200")
                            .fontCustom(.SemiBold, size: 16)
                            .foregroundColor(isCredit ? .greenColor : .redColor)
                    }
                    
                    HStack(spacing: spacing) {
                        Text(walletTransaction)
                            .fontCustom(.Regular, size: 15)
                            .foregroundColor(.darkGrayColor)
                        
                        Spacer()
                        
//                        if failed {
//                            Text(AppTexts.failed)
//                                .fontCustom(.Regular, size: 15)
//                                .foregroundColor(.redColor)
//                        }
                    }
                    
                }
                
                Spacer()
            }.padding(.horizontal, padding)
            
            Rectangle()
                .fill(Color.blackColor)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.leading, padding + (size/2))
        }
    }
}

struct WalletTransactionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        WalletTransactionsScreen()
    }
}
