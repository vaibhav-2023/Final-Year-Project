//
//  PaymentStatusView.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct PaymentStatusView: View {
    
    private let isPaymentSuccessfull: Bool
    private let isCredit: Bool
    
    init(isPaymentSuccessfull: Bool,
         isCredit: Bool) {
        self.isPaymentSuccessfull = isPaymentSuccessfull
        self.isCredit = isCredit
    }
    
    var body: some View {
        let icon: String
        let text: String
        if isPaymentSuccessfull {
            icon = "tickRoundIconTemplate"
            if isCredit {
                text = AppTexts.received
            } else {
                text = AppTexts.sent
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
        PaymentStatusView(isPaymentSuccessfull: true, isCredit: true)
    }
}
