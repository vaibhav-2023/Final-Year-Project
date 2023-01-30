//
//  MessageCell.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct MessageCell: View {
    
    private let message: String
    private let isSent: Bool
    private let isPayment: Bool
    
    private let spacing: CGFloat = 5
    private let padding: CGFloat = 16
    
    let maxWidth = DeviceDimensions.width * 0.7
    
    init(message: String, isSent: Bool) {
        self.message = message
        self.isSent = isSent
        isPayment = true
    }
    
    var body: some View {
        HStack {
            if isSent {
                Spacer(minLength: 1)
            }
            
            let alignment: HorizontalAlignment = isSent ? .trailing : .leading
            VStack(alignment: alignment, spacing: spacing) {
                CardView(useMaxWidth: false, backgroundColor: .lightBluishGrayColor, shadowColor: .primaryColor, shadowOpacity: 0.4, radius: 2, x: 2, y: 2) {
                    VStack(alignment: alignment, spacing: spacing) {
                        
                        if isPayment {
                            let isPaymentSuccessfull = true
                            HStack {
                                if isSent {
                                    Spacer(minLength: 1)
                                }
                                
                                Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                                    .foregroundColor(.blackColor)
                                    .fontCustom(.Medium, size: 16)
                                
                                Text("0")
                                    .foregroundColor(.blackColor)
                                    .fontCustom(.SemiBold, size: 40)
                                
                                if !isSent {
                                    Spacer(minLength: 1)
                                }
                            }.opacity(isPaymentSuccessfull ? 1 : 0.5)
                            
                            HStack(spacing: spacing) {
                                
                                PaymentStatusView(isPaymentSuccessfull: isPaymentSuccessfull, isCredit: !isSent)
                                
                                Spacer(minLength: 1)
                                
                                ImageView(imageName: "infoIconTemplate", isSystemImage: false)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.primaryColor)
                                
                            }
                        } else {
                            Text(message)
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
                    Text("13 Dec 2022 at 9:00 am")
                        .foregroundColor(.darkGrayColor)
                        .fontCustom(.Regular, size: 13)
                    if !isSent {
                        Spacer(minLength: 1)
                    }
                }
            }.frame(minWidth: 0, idealWidth: 0, maxWidth: maxWidth)
            
            if !isSent {
                Spacer(minLength: 1)
            }
        }
    }
}

struct MessageCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(message: "Message", isSent: false)
    }
}
