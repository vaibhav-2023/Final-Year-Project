//
//  PayToScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct PayToScreen: View {
    
    @State private var amount = ""
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: spacing) {
                    HStack(alignment: .top) {
                        let name = "Dummy Name"
                        VStack(alignment: .leading, spacing: spacing) {
                            Text(AppTexts.payTo)
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
                        
                        MyTextField("0", text: $amount, fontEnum: .SemiBold, textSize: 40, fixedSize: true)
                    }
                    
                    Spacer()
                    
                    CardView(backgroundColor: .lightBluishGrayColor) {
                        VStack {
                            HStack {
                                Text(AppTexts.payFrom + ":")
                                    .foregroundColor(.blackColor)
                                    .fontCustom(.Medium, size: 16)
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Text(AppTexts.changeBank)
                                        .foregroundColor(.primaryColor)
                                        .fontCustom(.SemiBold, size: 16)
                                }
                            }
                            
                            let bankName = "Dummy Bank"
                            let size = DeviceDimensions.width * 0.12
                            HStack(spacing: spacing) {
                                AvatarView(character: String(bankName.capitalized.first ?? " "), size: size)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(bankName)
                                        .fontCustom(.Medium, size: 16)
                                        .foregroundColor(.blackColor)
                                    
                                    Text("**** 1234")
                                        .fontCustom(.Regular, size: 13)
                                        .foregroundColor(.darkGrayColor)
                                }
                                
                                Spacer()
                            }.padding(.vertical, padding/2)
                            
                            MaxWidthButton(text: AppTexts.pay, fontEnum: .Medium) {
                                
                            }
                        }.padding()
                    }
                    
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
    }
}

struct PayToScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToScreen()
    }
}
