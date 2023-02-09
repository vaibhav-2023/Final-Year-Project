//
//  FillDetailsBankTransferScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 17/01/23.
//

import SwiftUI

struct FillDetailsBankTransferScreen: View {
    
    @State private var accountNumber: String = ""
    @State private var reEnterAccountNumber: String = ""
    @State private var ifsc: String = ""
    @State private var recipientName: String = ""
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(AppTexts.bank + " " + AppTexts.transfer)
                        .fontCustom(.SemiBold, size: 30)
                        .foregroundColor(.blackColor)
                    
                    LoginFieldsOuterView(title: AppTexts.accountNumber) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterAccountNumber,
                                    text: $accountNumber, maxLength: 18)
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.reenterAccountNumber) {
                        MyTextField(AppTexts.TextFieldPlaceholders.reenterAccountNumber,
                                    text: $reEnterAccountNumber, maxLength: 18)
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.ifsc) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterIFSC,
                                    text: $ifsc, maxLength: 11)
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.receipientName) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterReceipientName,
                                    text: $recipientName, maxLength: 11)
                    }.padding(.bottom, spacing)
                    
                    MaxWidthButton(text: AppTexts.save.uppercased(), fontEnum: .Medium) {
                        onSaveTapped()
                    }
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.bank + " " + AppTexts.transfer)
    }
    
    private func onSaveTapped() {
        if accountNumber.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterAccountNumber)
        } else if !accountNumber.isValidBankAccount {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidAccountNumber)
        } else if reEnterAccountNumber.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.reenterAccountNumber)
        } else if reEnterAccountNumber != accountNumber {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.accountNumberDoesNotMatch)
        } else if ifsc.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterIFSC)
        } else if !ifsc.isValidIFSC {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidIFSC)
        } else if recipientName.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterRecipientName)
        } else {
            Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.willBeAddedSoon)
        }
    }
}

struct FillDetailsBankTransferScreen_Previews: PreviewProvider {
    static var previews: some View {
        FillDetailsBankTransferScreen()
    }
}
