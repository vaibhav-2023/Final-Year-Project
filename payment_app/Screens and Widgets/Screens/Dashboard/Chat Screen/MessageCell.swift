//
//  MessageCell.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct MessageCell: View {
    
    //Values to be received updated on 17/01/23
    private let chatWalletTransaction: WalletTransactionModel?
    private let isSent: Bool
    private let isPayment: Bool
    
    //constants for spacing and padding
    private let spacing: CGFloat = 5
    private let padding: CGFloat = 16
    
    private let maxWidth = DeviceDimensions.width * 0.7
    
    //Constructors
    init(chatWalletTransaction: WalletTransactionModel?,
         isSent: Bool,
         isPayment: Bool) {
        self.chatWalletTransaction = chatWalletTransaction
        self.isSent = isSent
        self.isPayment = isPayment
    }
    
    //View to be shown
    var body: some View {
        HStack {
            //if message is sent space should be present in front
            if isSent {
                Spacer(minLength: 1)
            }
            
            let alignment: HorizontalAlignment = isSent ? .trailing : .leading
            VStack(alignment: alignment, spacing: spacing) {
                CardView(useMaxWidth: false, backgroundColor: .lightBluishGrayColor, shadowColor: .primaryColor, shadowOpacity: 0.4, radius: 2, x: 2, y: 2) {
                    VStack(alignment: alignment, spacing: spacing) {
                        
                        if isPayment {
                            let isPaymentSuccessfull = chatWalletTransaction?.isPaymentSuccessful ?? false
                            HStack {
                                if isSent {
                                    Spacer(minLength: 1)
                                }
                                
                                Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                                    .foregroundColor(.blackColor)
                                    .fontCustom(.Medium, size: 16)
                                
                                Text(chatWalletTransaction?.amount?.format() ?? "")
                                    .foregroundColor(.blackColor)
                                    .fontCustom(.SemiBold, size: 40)
                                
                                if !isSent {
                                    Spacer(minLength: 1)
                                }
                            }.opacity(isPaymentSuccessfull ? 1 : 0.5)
                            
                            if let remarks = chatWalletTransaction?.remarks, !remarks.isEmpty {
                                Text(remarks)
                                    .fontCustom(.Regular, size: 15)
                                    .foregroundColor(.blackColor)
                            }
                            
                            HStack(spacing: spacing) {
                                
                                PaymentStatusView(isPaymentSuccessfull: isPaymentSuccessfull, isDebit: isSent)
                                
                                Spacer(minLength: 1)
                                
                                ImageView(imageName: "infoIconTemplate", isSystemImage: false)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.primaryColor)
                                
                            }
                        } else {
                            Text(chatWalletTransaction?.remarks ?? "")
                                .fontCustom(.Regular, size: 15)
                                .foregroundColor(.blackColor)
                            
                            let isRead = true
                            ImageView(imageName: isRead ? "tickDoubleIconTemplate" : "tickIconTemplate", isSystemImage: false)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(isRead ? .primaryColor : .darkGrayColor)
                        }
                        
                    }.if (isPayment) { $0.padding(padding) }
                        .if (!isPayment) { $0.padding([.top, .horizontal], padding)
                                .padding(.bottom, padding / 2)
                        }
                }
                
                HStack {
                    if isSent {
                        Spacer(minLength: 1)
                    }
                    Text(chatWalletTransaction?.createdAt?.convertServerStringDate(toFormat: DateFormats.ddMMMYYYYathhmmaa) ?? "")
                        .foregroundColor(.darkGrayColor)
                        .fontCustom(.Regular, size: 13)
                    if !isSent {
                        Spacer(minLength: 1)
                    }
                }
            }.frame(minWidth: 0, idealWidth: 0, maxWidth: maxWidth)
            
            //if message is not sent, i.e., it is received space should be present in end
            if !isSent {
                Spacer(minLength: 1)
            }
        }
    }
}

struct MessageCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(chatWalletTransaction: nil, isSent: false, isPayment: false)
    }
}
