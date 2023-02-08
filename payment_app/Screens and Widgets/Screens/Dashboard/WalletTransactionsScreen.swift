//
//  WalletTransactionsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct WalletTransactionsScreen: View {
    
    @StateObject private var walletTransactionsVM = WalletTransactionsViewModel()
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            let count = walletTransactionsVM.walletTransactions.count
            if walletTransactionsVM.getWalletTransactionsAS == .ApiHit && count == 0 {
                EmptyListView(text: AppTexts.noTransactionsFound)
            } else if count != 0 {
                List {
                    ForEach(Array(walletTransactionsVM.walletTransactions.enumerated()), id: \.1) { index, walletTransaction in
                        walletTransactionCell(withDetails: walletTransaction)
                            .padding(.bottom, padding)
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
                    }
            } else {
                Spacer()
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.walletTransactions)
            .onAppear {
                walletTransactionsVM.getWalletTransactions()
            }
    }
    
    @ViewBuilder
    private func walletTransactionCell(withDetails walletTransaction: WalletTransactionModel?) -> some View {
        let size = DeviceDimensions.width * 0.12
        let isCredit = Singleton.sharedInstance.generalFunctions.getUserID() ==  walletTransaction?.paidByUserID?.id
        let isPaymentSuccessfull = walletTransaction?.isPaymentSuccessful ?? false
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                AvatarView(character: String(walletTransaction?.id?.capitalized.first ?? " "), size: size)
        
                VStack(spacing: 2) {
                    HStack(spacing: spacing) {
                        Text((walletTransaction?.paidToUserID?.name ?? "").capitalized)
                            .fontCustom(.Medium, size: 16)
                            .foregroundColor(.blackColor)
                        
                        Spacer()
                        
                        let amount = Singleton.sharedInstance.generalFunctions.getCurrencySymbol() + (walletTransaction?.amount?.format() ?? "")
                        Text((isCredit ? "+" : "-") + " " + amount)
                            .fontCustom(.SemiBold, size: 16)
                            .foregroundColor(isCredit ? .greenColor : .redColor)
                    }
                    
                    HStack(spacing: spacing) {
                        Text(walletTransaction?.id ?? "")
                            .fontCustom(.Regular, size: 15)
                            .foregroundColor(.darkGrayColor)
                        
                        Spacer()
                        
                        if !isPaymentSuccessfull {
                            Text(AppTexts.failed)
                                .fontCustom(.Regular, size: 15)
                                .foregroundColor(.redColor)
                        }
                    }
                    
                }
                
                Spacer()
            }.padding(.horizontal, padding)
            
            Rectangle()
                .fill(Color.blackColor)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.leading, padding + (size/2))
        }
    }
}

struct WalletTransactionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        WalletTransactionsScreen()
    }
}
