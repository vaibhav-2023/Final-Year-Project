//
//  BankAccountsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

//Show Bank User Bank Accounts Screen Created on 05/01/23
struct BankAccountsScreen: View {
    
    //for handling view model
    @StateObject private var profileVM = ProfileViewModel()
    
    //Variables used for view
    @State private var scrollViewReader: ScrollViewProxy?
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //View to be shown
    var body: some View {
        ZStack {
            let count = profileVM.userModel?.banks?.count ?? 0
            //if api is hit and user bank accounts are empty show empty view
            if profileVM.profileAPIAS == .ApiHit && count == 0 {
                EmptyListView(text: AppTexts.noBankAccountsAdded)
            } else if count != 0 {
                //if user bank accounts are not empty show all
                ScrollViewReader { scrollViewReader in
                    List {
                        ForEach(Array((profileVM.userModel?.banks ?? []).enumerated()), id: \.1) { index, bankAccountDetails in
                            BankAccountCell(bankAccountDetails: bankAccountDetails) {
                                //check balance button with toast will be added soon
                                Button {
                                    Singleton.sharedInstance.alerts.showToast(withMessage: AppTexts.willBeAddedSoon)
                                } label: {
                                    Text(AppTexts.checkBalance)
                                        .foregroundColor(.greenColor)
                                        .fontCustom(.Regular, size: 13)
                                }
                            }.padding([.bottom, .horizontal], padding)
                                .if(index == 0) { $0.padding(.top, padding) }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowBackground(Color.clear)
                                .id(index)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }.listStyle(PlainListStyle())
                        .onTapGesture {
                            return
                        }
                        .onLongPressGesture(minimumDuration: 0.1) {
                            return
                        }.onAppear {
                            //update scroll view value in scroll view reader
                            self.scrollViewReader = scrollViewReader
                        }
                }
            } else {
                Spacer()
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.bankAccounts)
            .onAppear {
                //when ever the screen appears fetch profile of user along with user bank accounts
                profileVM.getProfile()
            }
    }
}

struct BankAccountsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountsScreen()
    }
}
