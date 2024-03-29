//
//  FillBankDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct FillBankDetailsScreen: View {
    
    //environment variable to pop the screen
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //For Handling View Model added on 11/01/23
    @StateObject private var allBanksVM = AllBanksViewModel()
    @StateObject private var userBanksVM = UserBanksViewModel()
    
    //Variables used for navigation and presentation
    @State private var showBanksListSheet: Bool = false
    @State private var selection: Int? = nil
    
    //Variables used for view
    @State private var selectedBank: BankModel? = nil
    @State private var bankAccount: String = ""
    @State private var ifsc: String = ""
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    private let isUserFromContentView: Bool
    
    //Constructors
    init(isUserFromContentView: Bool) {
        self.isUserFromContentView = isUserFromContentView
    }
    
    //View to be shown
    var body: some View {
        ZStack {
            NavigationLink(destination: HomeScreen(), tag: NavigationEnum.HomeScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    HStack(alignment: .top) {
                        Text(AppTexts.bankDetails)
                            .fontCustom(.SemiBold, size: 30)
                            .foregroundColor(.blackColor)
                        
                        Spacer()
                        
                        if isUserFromContentView {
                            Button {
                                Singleton.sharedInstance.appEnvironmentObject.changeContentView.toggle()
                            } label: {
                                Text(AppTexts.skip)
                                    .fontCustom(.Regular, size: 13)
                                    .foregroundColor(.primaryColor)
                            }
                        }
                    }
                    
                    Text(AppTexts.addBankDetailsForVerification)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    VStack(alignment: .trailing, spacing: spacing/2) {
                        LoginFieldsOuterView(title: AppTexts.bank) {
                            MyTextField(AppTexts.TextFieldPlaceholders.selectBank, text: .constant((selectedBank?.name ?? "").capitalized))
                        }
                            .disabled(true)
                        
                        Button {
                            showBanksListSheet = true
                        } label: {
                            Text(selectedBank == nil ? AppTexts.selectBank : AppTexts.changeBank)
                                .fontCustom(.Medium, size: 16)
                                .foregroundColor(.primaryColor)
                        }
                    }.padding(.top, spacing * 2)
                    
                    LoginFieldsOuterView(title: AppTexts.bankAccount) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterBankAccount, text: $bankAccount, maxLength: 18)
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.ifsc) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterIFSC, text: $ifsc, maxLength: 11)
                    }.padding(.bottom, spacing)
                    
                    MaxWidthButton(text: AppTexts.proceed.uppercased(), fontEnum: .Medium) {
                        onSaveTapped()
                    }
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.addBankAccount)
            .showLoader(isPresenting: .constant(userBanksVM.isAnyApiBeingHit || allBanksVM.isAnyApiBeingHit))
            .sheet(isPresented: $showBanksListSheet) {
                SelectBankScreen(allBanksVM: allBanksVM, selectedBank: $selectedBank, isPresenting: $showBanksListSheet)
            }.onAppear {
                allBanksVM.getAllBanks()
            }.onReceive(userBanksVM.$addBankAS) { addBankAS in
                //updated on 11/01/23
                if addBankAS == .ApiHit {
                    if isUserFromContentView {
                        Singleton.sharedInstance.appEnvironmentObject.changeContentView.toggle()
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
    
    //button on click updated on 11/01/23
    private func onSaveTapped() {
        if selectedBank == nil {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.selectBank)
        } else if bankAccount.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterBankAccount)
        } else if !bankAccount.isValidBankAccount {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidBankAccount)
        } else if ifsc.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterIFSC)
        } else if !ifsc.isValidIFSC {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidIFSC)
        } else {
            userBanksVM.addBankAccount(ofBank: selectedBank, withAccountNumber: bankAccount, andIFSC: ifsc)
        }
    }
}

struct FillBankDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FillBankDetailsScreen(isUserFromContentView: false)
    }
}
