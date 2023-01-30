//
//  ProfileScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct ProfileScreen: View {
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
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
                        
                        AvatarView(character: "\(name.capitalized.first ?? " ")", strokeColor: .whiteColorForAllModes, lineWidth: 1)
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
                
                CardView(backgroundColor: .lightBluishGrayColor) {
                    VStack(spacing: spacing * 2) {
                        listTile(withTitle: AppTexts.profile) {
                            
                        }
                        listTile(withTitle: AppTexts.qrCode) {
                            
                        }
                        listTile(withTitle: AppTexts.bankAccount) {
                            
                        }
                        listTile(withTitle: AppTexts.privacyPolicy) {
                            
                        }
                        listTile(withTitle: AppTexts.termsAndConditions) {
                            
                        }
                    }.padding(.vertical, spacing * 2)
                }.padding(padding)
            }
        }
    }
    
    @ViewBuilder
    private func listTile(withTitle title: String, iconPressed: @escaping () -> Void) -> some View {
        Button {
            iconPressed()
        } label: {
            VStack(spacing: 5) {
                
                HStack {
                    Text(title)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    Spacer()
                    
                    ImageView(imageName: "forwardIconTemplate",
                              isSystemImage: false)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.blackColor)
                }.padding(.horizontal, padding)
                
                Rectangle()
                    .fill(Color.blackColor)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .padding(.leading, padding * 2)
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
