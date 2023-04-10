//
//  ProfileScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct ProfileScreen: View {
    
    //For Handling View Model added on 06/01/23
    @StateObject private var profileVM = ProfileViewModel()
    
    //variable used for navigation
    @State private var selection: Int? = nil
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //View to be shown
    var body: some View {
        ZStack {
            addNavigationLinks()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .bottom) {
                            //updated on 06/01/23
                            let name = (profileVM.userModel?.name ?? "").capitalized
                            VStack(alignment: .leading, spacing: spacing) {
                                Text(name)
                                    .fontCustom(.SemiBold, size: 30)
                                    .foregroundColor(.blackColorForAllModes)
                            }
                            
                            Spacer()
                            
                            AvatarView(character: "\(name.capitalized.first ?? " ")", strokeColor: .whiteColorForAllModes, lineWidth: 1)
                        }
                        
                        let vpaID = profileVM.userModel?.vpa ?? ""
                        Button {
                            UIPasteboard.general.string = vpaID
                            Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.AlertMessages.copiedToClipboard)
                        } label: {
                            HStack {
                                Text("\(AppTexts.vpaID):- \(vpaID)")
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
                    
                    if let decodedData = profileVM.userModel?.qrCodeFile?.removeString(AppTexts.extraTextInFrontOfbase64String).base64StringToData, let image = UIImage(data: decodedData) {
                        let width = DeviceDimensions.width * 0.6
                        Image(uiImage: image)
                            .resizable()
                            .foregroundColor(.blackColor)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: width)
                            .padding([.top, .horizontal], padding)
                        
                        Button {
                            Singleton.sharedInstance.generalFunctions.share(items: [image])
                        } label: {
                            Text(AppTexts.shareQRCode)
                                .fontCustom(.Medium, size: 17)
                                .foregroundColor(.primaryColor)
                                .padding(.vertical, padding/2)
                                .padding(.horizontal, padding)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.primaryColor, lineWidth: 1)
                                )
                        }.padding(padding)
                    }
                    
                    CardView(backgroundColor: .lightBluishGrayColor) {
                        VStack(spacing: spacing * 2) {
                            listTile(withTitle: AppTexts.profile) {
                                selection = NavigationEnum.ProfileInfoScreen.rawValue
                            }
                            listTile(withTitle: AppTexts.rechargeWallet) {
                                selection = NavigationEnum.RechargeWalletScreen.rawValue
                            }
                            listTile(withTitle: AppTexts.checkBalance) {
                                selection = NavigationEnum.CheckWalletBalanceScreen.rawValue
                            }
                            //                            listTile(withTitle: AppTexts.qrCode) {
                            //                                selection = NavigationEnum.QRCodeInfoScreen.rawValue
                            //                            }
                            //                            listTile(withTitle: AppTexts.bankAccount) {
                            //                                selection = NavigationEnum.BankAccountsScreen.rawValue
                            //                            }
                            listTile(withTitle: AppTexts.privacyPolicy) {
                                
                            }
                            listTile(withTitle: AppTexts.termsAndConditions) {
                                
                            }
                            listTile(withTitle: AppTexts.logout) {
                                Singleton.sharedInstance.alerts.alertWith(title: AppTexts.logout + "?", message: AppTexts.AlertMessages.areYouSureYouWantToLogoutFromApp + "?", defaultButtonTitle: AppTexts.logout, defaultButtonAction: {_ in
                                    //updated on 06/01/23
                                    if !profileVM.isAnyApiBeingHit {
                                        profileVM.logoutUser()
                                    }
//                                    Singleton.sharedInstance.generalFunctions.deinitilseAllVariables()
                                }, cancelButtonTitle: AppTexts.cancel)
                            }
                        }.padding(.vertical, spacing * 2)
                    }.padding(padding)
                }
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.profile)
            .showLoader(isPresenting: .constant(profileVM.isAnyApiBeingHit))
            .onAppear {
                profileVM.getProfile()
            }
    }
    
    //for navigation in the app
    @ViewBuilder
    private func addNavigationLinks() -> some View {
        NavigationLink(destination: ProfileInfoScreen(), tag: NavigationEnum.ProfileInfoScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: CheckWalletBalanceScreen(), tag: NavigationEnum.CheckWalletBalanceScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: RechargeWalletScreen(), tag: NavigationEnum.RechargeWalletScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: QRCodeInfoScreen(), tag: NavigationEnum.QRCodeInfoScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: BankAccountsScreen(), tag: NavigationEnum.BankAccountsScreen.rawValue, selection: $selection) {
            EmptyView()
        }
    }
    
    //to show options in the view
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
