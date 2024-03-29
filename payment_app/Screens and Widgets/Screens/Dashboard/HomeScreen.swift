//
//  HomeScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct HomeScreen: View {
    
    //Environment Object for handling state of the app
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    
    //For Handling View Model added on 07/01/23
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var cameraVM = CameraViewModel()
    
    //Variables used for navigation and presentation
    @State private var selection: Int? = nil
    @State private var scanResult: String? = nil
    @State private var qrCodeScannedModel: QrCodeScannedModel? = nil
    
    //constants for VGrid
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
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
                                AvatarView(imageURL: (profileVM.userModel?.profilePic ?? ""),
                                    character: "\(name.capitalized.first ?? " ")",
                                    strokeColor: .whiteColorForAllModes, lineWidth: 1)
                            }
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
                    
                    VStack(spacing: spacing) {
                        CardView(backgroundColor: .lightBluishGrayColor) {
                            LazyVGrid(columns: columns, spacing: spacing * 2) {
                                icon("qrCodeScannerIconTemplate", title: AppTexts.scan + "\n" + AppTexts.qr) {
                                    selection = NavigationEnum.ScanQRScreen.rawValue
                                }
                                icon("contactsIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.contact) {
                                    //Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.willBeAddedSoon)
                                    selection = NavigationEnum.PayToContactScreen.rawValue
                                }
                                icon("requestTransferIconTemplate", title: AppTexts.request + "\n" + AppTexts.transfer) {
                                    selection = NavigationEnum.RequestTransferScreen.rawValue
                                }
                                
                                icon("creditCardIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.vpaID) {
                                    selection = NavigationEnum.PayToVPAIDScreen.rawValue
                                }
                                icon("phoneForwardedIconTemplate", title: AppTexts.payTo + "\n" + AppTexts.number) {
                                    selection = NavigationEnum.PayToNumberScreen.rawValue
                                }
                                icon("accountBalanceIconTemplate", title: AppTexts.bank + "\n" + AppTexts.transfer) {
                                    Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.willBeAddedSoon)
                                    //selection = NavigationEnum.FillDetailsBankTransferScreen.rawValue
                                }
                                //icon("personPinIconTemplate", title: AppTexts.selfString + "\n" + AppTexts.transfer) {
                                //    Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.willBeAddedSoon)
                                //}
                            }.padding(.vertical, padding * 2)
                                .padding(.horizontal, spacing)
                        }
                        
                        listTile("qrCodeIconTemplate", title: AppTexts.qrCode) {
                            //selection = NavigationEnum.QRCodeInfoScreen.rawValue
                            selection = NavigationEnum.ProfileScreen.rawValue
                        }
                        
                        listTile("clockIconTemplate", title: AppTexts.walletTransactions) {
                            selection = NavigationEnum.WalletTransactionsScreen.rawValue
                        }
                        
                        listTile("walletBalanceIconTemplate", title: AppTexts.checkBalance) {
                            selection = NavigationEnum.CheckWalletBalanceScreen.rawValue
                        }
                        
//                        listTile("walletBalanceIconTemplate", title: AppTexts.checkBalance) {
//                            selection = NavigationEnum.BankAccountsScreen.rawValue
//                        }
                    }.padding(padding)
                }
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .onAppear {
                profileVM.getProfile()
                if let _ = appEnvironmentObject.walletTransactionDetails {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selection = NavigationEnum.PaymentDetailsScreen.rawValue
                    }
                }
            }.onChange(of: scanResult) { scanResult in
                //code added on 16/01/23 for qr code scanning
                print("IMP scan Result =", scanResult ?? "no data received")
                if let scanResult {
                    if let qrCodeToURL = URL(string: scanResult),
                       let queryParameters = qrCodeToURL.queryParameters {
                        let qrCodeScannedModel = Singleton.sharedInstance.generalFunctions.jsonToStruct(json: queryParameters, decodingStruct: QrCodeScannedModel.self)
                        //if String(qrCodeScannedModel?.pa?.prefix(10) ?? "").containsPhoneNumber() {
                        if let pa = qrCodeScannedModel?.pa, !pa.isEmpty, pa.contains(Singleton.sharedInstance.generalFunctions.getUserModel()?.vpa ?? "") != true {
                            self.qrCodeScannedModel = qrCodeScannedModel
                            selection = NavigationEnum.PayToScreen.rawValue
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                Singleton.sharedInstance.alerts.errorAlertWith(message: "Cannot transfer payment to this QR Code")
                            }
                        }
                    }
                    self.scanResult = nil
                }
            }
            .setNavigationBarTitle(title: AppTexts.home)
    }
    
    //naivgation links in app
    @ViewBuilder
    private func addNavigationLinks() -> some View {
        Group {
            NavigationLink(destination: ProfileScreen(), tag: NavigationEnum.ProfileScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            //no need to keep it in navigation stack camera conditions are handled in this class
            ScanQRScreen(cameraVM: cameraVM, selection: $selection, scanResult: $scanResult)
            
            NavigationLink(destination: PayToNumberScreen(), tag: NavigationEnum.PayToNumberScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: PayToContactScreen(), tag: NavigationEnum.PayToContactScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: PayToVPAIDScreen(), tag: NavigationEnum.PayToVPAIDScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: RequestTransferScreen(), tag: NavigationEnum.RequestTransferScreen.rawValue, selection: $selection) {
                EmptyView()
            }
        }
        
        Group {
            NavigationLink(destination: QRCodeInfoScreen(), tag: NavigationEnum.QRCodeInfoScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: WalletTransactionsScreen(), tag: NavigationEnum.WalletTransactionsScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: CheckWalletBalanceScreen(), tag: NavigationEnum.CheckWalletBalanceScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
//            NavigationLink(destination: BankAccountsScreen(), tag: NavigationEnum.BankAccountsScreen.rawValue, selection: $selection) {
//                EmptyView()
//            }
            
            NavigationLink(destination: FillDetailsBankTransferScreen(), tag: NavigationEnum.FillDetailsBankTransferScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: PayToScreen(qrCodeScannedModel: $qrCodeScannedModel), tag: NavigationEnum.PayToScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: PaymentDetailsScreen(walletTransactionsDetails: appEnvironmentObject.walletTransactionDetails), tag: NavigationEnum.PaymentDetailsScreen.rawValue, selection: $selection) {
                EmptyView()
            }
        }
    }
    
    //icon button
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
    
    //list tile options
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
                    .foregroundColor(.blackColor)
                
                Spacer()
                
                ImageView(imageName: "forwardIconTemplate",
                          isSystemImage: false)
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .foregroundColor(.primaryColor)
                
            }.padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.clear)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.primaryColor, lineWidth: lineWidth))
                .padding(lineWidth)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
