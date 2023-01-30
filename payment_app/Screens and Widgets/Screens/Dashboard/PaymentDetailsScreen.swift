//
//  PaymentDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct PaymentDetailsScreen: View {
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                let isCredit = true
                let isPaymentSuccessfull = true
                
                VStack(spacing: spacing) {
                    HStack(alignment: .top) {
                        let name = "Dummy Name"
                        VStack(alignment: .leading, spacing: spacing) {
                            Text(isCredit ? AppTexts.from : AppTexts.to)
                                .fontCustom(.Medium, size: 16)
                                .foregroundColor(.blackColorForAllModes)
                            
                            Text(name)
                                .fontCustom(.SemiBold, size: 30)
                                .foregroundColor(.blackColorForAllModes)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            AvatarView(character: "\(name.capitalized.first ?? " ")", strokeColor: .whiteColorForAllModes, lineWidth: 1)
                        }
                    }
                    
                    Text("\(AppTexts.mobileNumber):- +919876543210")
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColorForAllModes)
                        .padding(.top, padding)
                    
                }.padding(.top, padding * 2)
                    .padding(.horizontal, padding)
                    .padding(.bottom, padding / 2)
                    .background(LinearGradient(gradient: Gradient(colors: [.lightPrimaryColor, .defaultLightGray]), startPoint: .top, endPoint: .bottom))
                
                Rectangle()
                    .fill(Color.blackColor)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                
                VStack(spacing: spacing) {
                    let price: Double = 2000
                    HStack {
                        Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                            .foregroundColor(.blackColor)
                            .fontCustom(.Medium, size: 16)
                        
                        Text("\(price.format())")
                            .foregroundColor(.blackColor)
                            .fontCustom(.SemiBold, size: 40)
                    }.padding(.top, padding)
                    
                    let prefix = price > 1 ? AppTexts.ruppees : AppTexts.ruppee
                    textView((price.getNumberWords() + " " + prefix + " " + AppTexts.only).capitalized)
                        .padding(.bottom, padding)
                    
                    PaymentStatusView(isPaymentSuccessfull: isPaymentSuccessfull, isCredit: isCredit)
                        .padding(.top, padding)
                    
                    textView("on 12 Dec 2022 at 9:38 am")
                        .padding(.bottom, padding)
                    
                    VStack(spacing: padding) {
                        Text("\(AppTexts.transactionID):")
                            .foregroundColor(.blackColor)
                            .fontCustom(.Medium, size: 16)
                        
                        userDetails(title: AppTexts.from, userDetails: "Dummy Name")
                        userDetails(title: AppTexts.to, userDetails: "Dummy Name")
                    }
                    
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func textView(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.darkGrayColor)
            .fontCustom(.Regular, size: 13)
    }
    
    @ViewBuilder
    private func userDetails(title: String, userDetails: String) -> some View {
        CardView(backgroundColor: .lightBluishGrayColor) {
            VStack(alignment: .leading, spacing: spacing) {
                HStack {
                    Text(title + ":-")
                        .foregroundColor(.blackColor)
                        .fontCustom(.Regular, size: 15)
                    Spacer()
                }
                
                Text(userDetails)
                    .foregroundColor(.blackColor)
                    .fontCustom(.Medium, size: 16)
            }.padding(padding)
        }
    }
}

struct PaymentDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailsScreen()
    }
}
