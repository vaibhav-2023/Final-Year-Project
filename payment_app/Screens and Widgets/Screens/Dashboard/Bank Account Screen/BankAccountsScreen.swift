//
//  BankAccountsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct BankAccountsScreen: View {
    
    @StateObject private var profileVM = ProfileViewModel()
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            let count = profileVM.userModel?.banks?.count ?? 0
            if profileVM.profileAPIAS == .ApiHit && count == 0 {
                EmptyListView(text: AppTexts.noBankAccountsAdded)
            } else if count != 0 {
                List {
                    ForEach(Array((profileVM.userModel?.banks ?? []).enumerated()), id: \.1) { index, bankAccountDetails in
                        BankAccountCell(bankAccountDetails: bankAccountDetails) {
                            Button {
                                
                            } label: {
                                Text(AppTexts.checkBalance)
                                    .foregroundColor(.greenColor)
                                    .fontCustom(.Regular, size: 13)
                            }
                            .padding(.bottom, padding)
                            .if(index == 0) { $0.padding(.top, padding) }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                            .id(index)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }.listStyle(PlainListStyle())
                    .onTapGesture {
                        return
                    }
                    .onLongPressGesture(minimumDuration: 0.1) {
                        return
                    }
            } else {
                Spacer()
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.bankAccounts)
            .onAppear {
                profileVM.getProfile()
            }
        
        
    }
}

struct BankAccountsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountsScreen()
    }
}
