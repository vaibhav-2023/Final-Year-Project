//
//  QRCodeInfoScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI

struct QRCodeInfoScreen: View {
    
    @StateObject private var profileVM = ProfileViewModel()
    
    @State private var selection: Int? = nil
    @State private var showSelectBankSheet: Bool = false
    @State private var selectedBankAccount: UserAddedBankAccountModel? = nil
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination: FillBankDetailsScreen(isUserFromContentView: false), tag: NavigationEnum.FillBankDetails.rawValue, selection: $selection) {
                EmptyView()
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .bottom) {
                            let name = (profileVM.userModel?.name ?? "").capitalized
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
                            Text(AppTexts.selectedBank + ":")
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
                        
                        let bankName = selectedBankAccount?.accountNumber ?? ""
                        let size = DeviceDimensions.width * 0.12
                        HStack(spacing: spacing) {
                            AvatarView(character: String(bankName.capitalized.first ?? " "), size: size, strokeColor: .whiteColorForAllModes, lineWidth: 1)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(bankName)
                                    .fontCustom(.Medium, size: 16)
                                    .foregroundColor(.blackColor)
                         
                                let bankAccountSuffix4: String = String((selectedBankAccount?.accountNumber  ?? "").suffix(4))
                                Text("**** \(bankAccountSuffix4)")
                                    .fontCustom(.Regular, size: 13)
                                    .foregroundColor(.darkGrayColor)
                            }
                            
                            Spacer()
                        }
                        
                    }.padding(padding)
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .sheet(isPresented: $showSelectBankSheet) {
                SelectBankAccountSheet(profileVM: profileVM,
                                       isPresenting: $showSelectBankSheet,
                                       selectedBankAccount: $selectedBankAccount,
                                       selection: $selection)
            }.setNavigationBarTitle(title: AppTexts.qrCode)
            .onAppear {
                profileVM.getProfile()
            }.onReceive(profileVM.$profileAPIAS) { apiStatus in
                if apiStatus == .ApiHit,
                   selectedBankAccount == nil,
                   let banks = profileVM.userModel?.banks,
                   !banks.isEmpty,
                   let defaultBank = banks.first as? UserAddedBankAccountModel {
                    selectedBankAccount = defaultBank
                }
            }
    }
}

struct QRCodeInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeInfoScreen()
    }
}
