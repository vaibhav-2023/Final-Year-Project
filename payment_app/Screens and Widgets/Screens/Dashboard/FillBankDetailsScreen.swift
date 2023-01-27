//
//  FillBankDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct FillBankDetailsScreen: View {
    @StateObject private var profileVM = ProfileViewModel()
    
    @State private var selection: Int? = nil
    
    @State private var selectedbank: String? = nil
    @State private var bankAccount: String = ""
    @State private var ifsc: String = ""
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            NavigationLink(destination: HomeScreen(), tag: NavigationEnum.HomeScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(AppTexts.bankDetails)
                        .fontCustom(.SemiBold, size: 30)
                        .foregroundColor(.blackColor)
                    
                    Text(AppTexts.addBankDetailsForVerification)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    VStack(alignment: .trailing, spacing: spacing/2) {
                        LoginFieldsOuterView(title: AppTexts.bank) {
                            MyTextField(AppTexts.TextFieldPlaceholders.selectBank, text: $bankAccount)
                        }
                            .disabled(true)
                        
                        Button {
                            
                        } label: {
                            Text(selectedbank == nil ? AppTexts.selectBank : AppTexts.changeBank)
                                .fontCustom(.Medium, size: 16)
                                .foregroundColor(.primaryColor)
                        }
                    }.padding(.top, spacing * 2)
                    
                    LoginFieldsOuterView(title: AppTexts.bankAccount) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterBankAccount, text: $bankAccount)
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.ifsc) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterIFSC, text: $ifsc)
                    }.padding(.bottom, spacing)
                    
                    MaxWidthButton(text: AppTexts.save.uppercased(), fontEnum: .Medium) {
                        onSaveTapped()
                    }
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .showLoader(isPresenting: .constant(profileVM.isAnyApiBeingHit))
            .onReceive(profileVM.$fillDetailsAS) { fillDetailsAS in
                if fillDetailsAS == .ApiHit {
                    //selection = NavigationEnum.OTPVerify.rawValue
                }
            }
    }
    
    private func onSaveTapped() {
        if selectedbank == nil {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.selectBank)
        } else if bankAccount.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterBankAccount)
        } else if !ifsc.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterIFSC)
        } else {
            
        }
    }
}

struct FillBankDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FillBankDetailsScreen()
    }
}
