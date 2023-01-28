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
                            AvatarView(character: "\(name.capitalized.first ?? " ")")
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
                    HStack {
                        Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                            .foregroundColor(.blackColor)
                            .fontCustom(.Medium, size: 16)
                        
                        Text("0")
                            .foregroundColor(.blackColor)
                            .fontCustom(.SemiBold, size: 40)
                    }.padding(.top, padding)
                    
                    textView("on 12 Dec 2022 at 9:38 am")
                        .padding(.bottom, padding)
                    
                    showStatusView(isPaymentSuccessfull: isPaymentSuccessfull, isCredit: isCredit)
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
    
    private func showStatusView(isPaymentSuccessfull: Bool, isCredit: Bool) -> some View {
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
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(isPaymentSuccessfull ? .greenColor : .redColor)
            
            Text(text)
                .foregroundColor(.blackColor)
                .fontCustom(.Medium, size: 18)
        }
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
