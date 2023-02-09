//
//  PayToScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct PayToScreen: View {
    
    @StateObject private var userDetailsVM = UserDetailsViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var paymentVM = PaymentViewModel()
    
    @State private var qrCodeScannedModel: QrCodeScannedModel? = nil
    @State private var amount = ""
    @State private var note = ""
    @State private var adjustableTVHeight: CGFloat = 34
    @State private var showSelectBankSheet: Bool = false
    @State private var selection: Int? = nil
    @State private var selectedBankAccount: UserAddedBankAccountModel? = nil
    
    @Binding private var qrScannedResultFromPreviousScreen: QrCodeScannedModel?
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    private let payToUserModel: UserModel?
    
    init(payToUserModel: UserModel? = nil,
         qrCodeScannedModel: Binding<QrCodeScannedModel?> = .constant(nil)) {
        self._qrScannedResultFromPreviousScreen = qrCodeScannedModel
        self.payToUserModel = payToUserModel
    }
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination: FillBankDetailsScreen(isUserFromContentView: false), tag: NavigationEnum.FillBankDetails.rawValue, selection: $selection) {
                EmptyView()
            }
            
            VStack(spacing: 0) {
                VStack(spacing: spacing) {
                    HStack(alignment: .top) {
                        let name = (userDetailsVM.userDetails?.name ?? "").capitalized
                        VStack(alignment: .leading, spacing: spacing) {
                            Text(AppTexts.payTo)
                                .fontCustom(.Medium, size: 16)
                                .foregroundColor(.blackColorForAllModes)
                            
                            Text(name)
                                .fontCustom(.SemiBold, size: 30)
                                .foregroundColor(.blackColorForAllModes)
                        }
                        
                        Spacer()
                        
//                        Button {
//
//                        } label: {
                            AvatarView(character: "\(name.capitalized.first ?? " ")", strokeColor: .whiteColorForAllModes, lineWidth: 1)
//                        }
                    }
                    
                    let mobileNumber = (userDetailsVM.userDetails?.numericCountryCode ?? "") + " " + (userDetailsVM.userDetails?.phone ?? "")
                    Text("\(AppTexts.mobileNumber):- \(mobileNumber)")
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
                        
                        MyTextField("0", text: $amount, fontEnum: .SemiBold, textSize: 40, maxLength: 6, keyboardType: .numberPad, fixedSize: true)
                    }
                    
                    LoginFieldsOuterView {
                        MyTextView(AppTexts.TextFieldPlaceholders.noteIfAny + "...",
                                   text: $note,
                                   isAdjustableTV: true,
                                   adjustableTVHeight: $adjustableTVHeight,
                                   maxLength: 10)
                    }
                    
                    Spacer()
                    
                    CardView(backgroundColor: .lightBluishGrayColor) {
                        VStack {
                            if profileVM.userModel?.banks?.isEmpty == true {
                                MaxWidthButton(text: AppTexts.addBankAccount, fontEnum: .Medium) {
                                    selection = NavigationEnum.FillBankDetails.rawValue
                                }
                            } else {
                                HStack {
                                    Text(AppTexts.payFrom + ":")
                                        .foregroundColor(.blackColor)
                                        .fontCustom(.Medium, size: 16)
                                    
                                    Spacer()
                                    
                                    Button {
                                        showSelectBankSheet = true
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
                                }.padding(.vertical, padding/2)
                                
                                MaxWidthButton(text: AppTexts.pay, fontEnum: .Medium) {
                                    payBA()
                                }
                            }
                        }.padding()
                    }
                    
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .ignoresSafeArea(.keyboard)
            .showLoader(isPresenting: .constant(userDetailsVM.isAnyApiBeingHit || profileVM.isAnyApiBeingHit || paymentVM.isAnyApiBeingHit))
            .sheet(isPresented: $showSelectBankSheet) {
                SelectBankAccountSheet(profileVM: profileVM,
                                  isPresenting: $showSelectBankSheet,
                                  selectedBankAccount: $selectedBankAccount,
                                  selection: $selection)
            }
            .onAppear {
                if userDetailsVM.userDetails == nil, let payToUserModel {
                    userDetailsVM.setUserDetails(payToUserModel)
                }
                if let scannedResult = qrScannedResultFromPreviousScreen {
                    self.qrCodeScannedModel = scannedResult
                }
                qrScannedResultFromPreviousScreen = nil
                if let qrCodeScannedModel {
                    userDetailsVM.getUser(withQRCodeScannedModel: qrCodeScannedModel)
                } else {
                    userDetailsVM.getDetailsOfUser()
                }
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
    
    private func payBA() {
        let amountInInt = Int(amount) ?? 0
        let minimumAmountRequiredToRecharge = 1
        if amountInInt < minimumAmountRequiredToRecharge {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.amountShouldBeAtleast + " " + Singleton.sharedInstance.generalFunctions.getCurrencyCode() + "\(minimumAmountRequiredToRecharge)")
        } else {
            let toBankAccount: UserAddedBankAccountModel?
            if let banks = userDetailsVM.userDetails?.banks,
               !banks.isEmpty, let toBankAccountFirst = banks.first {
                toBankAccount = toBankAccountFirst
            } else {
                toBankAccount = nil
            }
            paymentVM.addWalletTransactions(fromBankAccount: selectedBankAccount,
                                            toUser: userDetailsVM.userDetails,
                                            toBankAccount: toBankAccount,
                                            withAmount: amount,
                                            andNote: note,
                                            isSuccessfull: true)
        }
    }
}

struct PayToScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToScreen()
    }
}
