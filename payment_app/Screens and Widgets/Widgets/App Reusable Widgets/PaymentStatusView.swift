//
//  PaymentStatusView.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

//Used when to show payment complete/error view
struct PaymentStatusView: View {
    
    private let isPaymentSuccessfull: Bool
    private let walletTransactionEnum: WalletTransactionEnum
    
    init(isPaymentSuccessfull: Bool,
         walletTransactionEnum: WalletTransactionEnum) {
        self.isPaymentSuccessfull = isPaymentSuccessfull
        self.walletTransactionEnum = walletTransactionEnum
    }
    
    var body: some View {
        let icon: String
        let text: String
        if isPaymentSuccessfull {
            icon = "tickRoundIconTemplate"
            switch walletTransactionEnum {
            case .debit:
                text = AppTexts.sent
            case .credit:
                text = AppTexts.received
            case .walletRecharge:
                text = AppTexts.walletRecharged
            }
        } else {
            icon = "errorIconTemplate"
            text = AppTexts.failed
        }
        
        return HStack {
            
            ImageView(imageName: icon, isSystemImage: false)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(isPaymentSuccessfull ? .greenColor : .redColor)
            
            Text(text)
                .foregroundColor(.blackColor)
                .fontCustom(.Medium, size: 18)
        }
    }
}

struct PaymentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentStatusView(isPaymentSuccessfull: true, walletTransactionEnum: .debit)
    }
}
