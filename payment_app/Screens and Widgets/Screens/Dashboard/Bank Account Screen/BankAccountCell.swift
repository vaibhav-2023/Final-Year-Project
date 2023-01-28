//
//  BankAccountCell.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct BankAccountCell<Content> : View where Content : View  {
    
    private let bankName: String
    private let content: Content
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    init(bankName: String,
         @ViewBuilder content: () -> Content) {
        self.bankName = bankName
        self.content = content()
    }
    
    var body: some View {
        let size = DeviceDimensions.width * 0.12
        CardView(backgroundColor: .lightBluishGrayColor, cornerRadius: 8, radius: 0) {
            HStack(spacing: spacing) {
                AvatarView(character: String(bankName.capitalized.first ?? " "), size: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(bankName)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    HStack {
                        Text("**** 1234")
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
        BankAccountCell(bankName: "Test") {
            Text("Testing")
        }
    }
}
