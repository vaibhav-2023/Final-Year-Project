//
//  BankAccountsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct BankAccountsScreen: View {
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            BankAccountCell(bankName: "Bank") {
                Button {
                    
                } label: {
                    Text(AppTexts.checkBalance)
                        .foregroundColor(.greenColor)
                        .fontCustom(.Regular, size: 13)
                }
            }.padding()
        }
            .background(Color.whiteColor.ignoresSafeArea())
    }
}

struct BankAccountsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountsScreen()
    }
}
