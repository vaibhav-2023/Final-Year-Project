//
//  HomeScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var cameraVM = CameraViewModel()
    
    @State private var selection: Int? = nil
    @State private var scanResult: String? = nil
    
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            addNavigationLinks()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .top) {
                            let name = (profileVM.userModel?.name ?? "").capitalized
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
                                selection = NavigationEnum.ProfileScreen.rawValue
                            } label: {
                                AvatarView(character: "\(name.capitalized.first ?? " ")", strokeColor: .whiteColorForAllModes, lineWidth: 1)
                            }
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
                    
                    VStack(spacing: spacing) {
                        CardView(backgroundColor: .lightBluishGrayColor) {
                            LazyVGrid(columns: columns, spacing: spacing * 2) {
                                icon("qrCodeScannerIconTemplate", title: AppTexts.scan + "\n" + AppTexts.qr) {
                                    selection = NavigationEnum.ScanQRScreen.rawValue
                                }
                                icon("contactsIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.contact) {
                                    selection = NavigationEnum.PayToNumberScreen.rawValue
                                }
                                icon("accountBalanceIconTemplate", title: AppTexts.bank + "\n" + AppTexts.transfer) {
                                    //selection = NavigationEnum.PayToNumberScreen.rawValue
                                }
                                
                                icon("creditCardIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.upiID) {
                                    selection = NavigationEnum.PayToUPIIDScreen.rawValue
                                }
                                
                                icon("phoneForwardedIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.number) {
                                    selection = NavigationEnum.PayToNumberScreen.rawValue
                                }
                                
                                icon("personPinIconTemplate", title: AppTexts.selfString + "\n" + AppTexts.transfer) {
                                    
                                }
                            }.padding(.vertical, padding * 2)
                                .padding(.horizontal, spacing)
                        }
                        
                        listTile("qrCodeIconTemplate", title: AppTexts.qrCode) {
                            selection = NavigationEnum.QRCodeInfoScreen.rawValue
                        }
                        
                        listTile("clockIconTemplate", title: AppTexts.walletTransactions) {
                            selection = NavigationEnum.WalletTransactionsScreen.rawValue
                        }
                        
                        listTile("walletBalanceIconTemplate", title: AppTexts.checkBalance) {
                            selection = NavigationEnum.BankAccountsScreen.rawValue
                        }
                    }.padding(padding)
                }
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.home)
            .onAppear {
                profileVM.getProfile()
            }.onChange(of: scanResult) { scanResult in
                if let _ = scanResult {
                    selection = NavigationEnum.PayToScreen.rawValue
                }
            }
    }
    
    @ViewBuilder
    private func addNavigationLinks() -> some View {
        NavigationLink(destination: ProfileScreen(), tag: NavigationEnum.ProfileScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        //no need to keep it in navigation stack camera conditions are handled in this class
        ScanQRScreen(cameraVM: cameraVM, selection: $selection, scanResult: $scanResult)
        
        NavigationLink(destination: PayToNumberScreen(), tag: NavigationEnum.PayToNumberScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: PayToUPIIDScreen(), tag: NavigationEnum.PayToUPIIDScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: QRCodeInfoScreen(), tag: NavigationEnum.QRCodeInfoScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: WalletTransactionsScreen(), tag: NavigationEnum.WalletTransactionsScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: BankAccountsScreen(), tag: NavigationEnum.BankAccountsScreen.rawValue, selection: $selection) {
            EmptyView()
        }
        
        NavigationLink(destination: PayToScreen(qrScannedResult: $scanResult), tag: NavigationEnum.PayToScreen.rawValue, selection: $selection) {
            EmptyView()
        }
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
