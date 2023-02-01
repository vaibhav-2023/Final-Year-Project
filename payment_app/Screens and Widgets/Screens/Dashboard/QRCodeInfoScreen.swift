//
//  QRCodeInfoScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI

struct QRCodeInfoScreen: View {
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .bottom) {
                            let name = "Dummy Name"
                            VStack(alignment: .leading, spacing: spacing) {
                                Text(name)
                                    .fontCustom(.SemiBold, size: 30)
                                    .foregroundColor(.blackColorForAllModes)
                            }
                            
                            Spacer()
                            
                            AvatarView(character: "\(name.capitalized.first ?? " ")", strokeColor: .whiteColorForAllModes, lineWidth: 1)
                        }
                        
                        let upiID = "upiid"
                        Button {
                            UIPasteboard.general.string = upiID
                            Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.AlertMessages.copiedToClipboard)
                        } label: {
                            HStack {
                                Text("\(AppTexts.upiID):- \(upiID)")
                                    .fontCustom(.Medium, size: 16)
                                    .foregroundColor(.blackColorForAllModes)
                                
                                ImageView(imageName: "contentCopyIconTemplate", isSystemImage: false)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blackColorForAllModes)
                            }.padding(.top, padding)
                        }
                        
                    }.padding(.top, padding * 2)
                        .padding(.horizontal, padding)
                        .padding(.bottom, padding / 2)
                        .background(LinearGradient(gradient: Gradient(colors: [.lightPrimaryColor, .defaultLightGray]), startPoint: .top, endPoint: .bottom))
                    
                    Rectangle()
                        .fill(Color.blackColor)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    
                    
                }
                
                
                CardView(backgroundColor: .lightBluishGrayColor) {
                    VStack(spacing: spacing) {
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
                            AvatarView(character: String(bankName.capitalized.first ?? " "), size: size, strokeColor: .whiteColorForAllModes, lineWidth: 1)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(bankName)
                                    .fontCustom(.Medium, size: 16)
                                    .foregroundColor(.blackColor)
                                
                                Text("**** 1234")
                                    .fontCustom(.Regular, size: 13)
                                    .foregroundColor(.darkGrayColor)
                            }
                            
                            Spacer()
                        }
                        
                    }.padding(padding)
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.qrCode)
    }
}

struct QRCodeInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeInfoScreen()
    }
}
