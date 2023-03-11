//
//  BankAccountCell.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

//Single Cell/Item to show Show Bank User Bank Account Created on 05/01/23
struct BankAccountCell<Content> : View where Content : View  {
    
    //Values to be received
    private let bankAccountDetails: UserAddedBankAccountModel?
    private let content: Content
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //Constructors
    init(bankAccountDetails: UserAddedBankAccountModel?,
         @ViewBuilder content: () -> Content) {
        self.bankAccountDetails = bankAccountDetails
        self.content = content()
    }
    
    //View to be shown
    var body: some View {
        let size = DeviceDimensions.width * 0.12
        CardView(backgroundColor: .lightBluishGrayColor, cornerRadius: 8, radius: 0) {
            HStack(alignment: .top, spacing: spacing) {
                AvatarView(character: String(bankAccountDetails?.accountNumber?.capitalized.first ?? " "), size: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(bankAccountDetails?.accountNumber ?? "")
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    HStack {
                        //show last four digits of account number
                        let bankAccountSuffix4: String = String((bankAccountDetails?.accountNumber  ?? "").suffix(4))
                        Text("**** \(bankAccountSuffix4)")
                            .fontCustom(.Regular, size: 13)
                            .foregroundColor(.darkGrayColor)
                        
                        Spacer()
                        
                        content
                    }
                }
                
            }.padding(padding)
        }
    }
}

struct BankAccountCell_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountCell(bankAccountDetails: nil) {
            Text("Testing")
        }
    }
}
