//
//  HomeScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct HomeScreen: View {
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .top) {
                            let name = "Dummy Name"
                            VStack(alignment: .leading, spacing: spacing) {
                                Text(AppTexts.greetings + ",")
                                    .fontCustom(.SemiBold, size: 30)
                                    .foregroundColor(.blackColorForAllModes)
                                
                                Text(name)
                                    .fontCustom(.Medium, size: 16)
                                    .foregroundColor(.blackColorForAllModes)
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                AvatarView(character: "\(name.capitalized.first ?? " ")")
                            }
                        }
                        
                        let upiID = "upiid"
                        Button {
                            UIPasteboard.general.string = upiID
                        } label: {
                            HStack {
                                Text("\(AppTexts.upiID):- \(upiID)")
                                    .fontCustom(.Medium, size: 16)
                                    .foregroundColor(.blackColorForAllModes)
                                
                                ImageView(imageName: "contentCopyIconTemplate", isSystemImage: false)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blackColorForAllModes)
                                    .aspectRatio(contentMode: .fit)
                            }.padding(.top, padding)
                        }
                        
                    }.padding(.top, padding * 2)
                        .padding(.horizontal, padding)
                        .padding(.bottom, padding / 2)
                        .background(LinearGradient(gradient: Gradient(colors: [.lightPrimaryColor, .defaultLightGray]), startPoint: .top, endPoint: .bottom))
                    
                    Rectangle()
                        .fill(Color.blackColor)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    
                    VStack(spacing: spacing) {
                        CardView(backgroundColor: .lightBluishGrayColor) {
                            VStack(spacing: spacing * 2) {
                                HStack {
                                    icon("qrCodeScannerIconTemplate", title: AppTexts.scan + "\n" + AppTexts.qr) {
                                        
                                    }
                                    Spacer()
                                    icon("contactsIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.contact) {
                                        
                                    }
                                    Spacer()
                                    icon("accountBalanceIconTemplate", title: AppTexts.bank + "\n" + AppTexts.transfer) {
                                        
                                    }
                                }
                                HStack {
                                    icon("creditCardIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.upiID) {
                                        
                                    }
                                    Spacer()
                                    icon("phoneForwardedIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.number) {
                                        
                                    }
                                    Spacer()
                                    icon("personPinIconTemplate", title: AppTexts.selfString + "\n" + AppTexts.transfer) {
                                        
                                    }
                                }
                            }.padding(.vertical, padding * 2)
                                .padding(.horizontal, spacing * 3.5)
                        }
                        
                        listTile("clockIconTemplate", title: AppTexts.walletTransactions)
                        {
                            
                        }
                        
                        listTile("walletBalanceIconTemplate", title: AppTexts.checkBalance)
                        {
                            
                        }
                    }.padding(padding)
                }
            }
        }
        .background(Color.whiteColor.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func icon(_ iconName: String, title: String, iconPressed: @escaping () -> Void) -> some View {
        Button {
            iconPressed()
        } label: {
            VStack {
                ImageView(imageName: iconName,
                          isSystemImage: false)
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundColor(.primaryColor)
                
                Text(title)
                    .fontCustom(.Regular, size: 15)
                    .foregroundColor(.blackColor)
            }
        }
    }
    
    @ViewBuilder
    private func listTile(_ iconName: String, title: String, iconPressed: @escaping () -> Void) -> some View {
        let cornerRadius: CGFloat = 5
        let lineWidth: CGFloat = 1
        
        Button {
            iconPressed()
        } label: {
            HStack {
                ImageView(imageName: iconName,
                          isSystemImage: false)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.whiteColorForAllModes)
                    .frame(width: 35, height: 35)
                    .background(Color.primaryColor)
                    .clipShape(Circle())
                
                Text(title)
                    .fontCustom(.Regular, size: 15)
                    .foregroundColor(.blackColorForAllModes)
                
                Spacer()
                
                ImageView(imageName: "forwardIconTemplate",
                          isSystemImage: false)
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .foregroundColor(.primaryColor)
                
            }.padding(.horizontal, 14)
                .padding(.vertical, 10)
            .background(Color.lightPrimaryColor)
            .cornerRadius(cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.primaryColor, lineWidth: lineWidth))
            .padding(lineWidth)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
