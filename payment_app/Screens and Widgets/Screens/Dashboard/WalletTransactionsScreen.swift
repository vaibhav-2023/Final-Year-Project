//
//  WalletTransactionsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct WalletTransactionsScreen: View {
    
    //for handling view model
    @StateObject private var walletTransactionsVM = WalletTransactionsViewModel()
    
    //Variables used for view
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var selection: Int? = nil
    @State private var selectedWalletTransaction: WalletTransactionModel? = nil
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //View to be shown
    var body: some View {
        ZStack {
            NavigationLink(destination: PaymentDetailsScreen(walletTransactionsDetails: selectedWalletTransaction), tag: NavigationEnum.PaymentDetailsScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            let count = walletTransactionsVM.walletTransactions.count
            //if api is hit and wallet transactions are empty show empty view
            if walletTransactionsVM.getWalletTransactionsAS == .ApiHit && count == 0 {
                EmptyListView(text: AppTexts.noTransactionsFound)
            } else if count != 0 {
                //if wallet transactions are not empty show all
                ScrollViewReader { scrollViewReader in
                    List {
                        Section(footer: !walletTransactionsVM.fetchedAllData ?
                                ListFooterProgressView()
                                : nil) {
                            ForEach(Array(walletTransactionsVM.walletTransactions.enumerated()), id: \.1) { index, walletTransaction in
                                walletTransactionCell(withDetails: walletTransaction)
                                    .padding(.bottom, padding)
                                    .if(index == 0) { $0.padding(.top, padding) }
                                    .onAppear {
                                        walletTransactionsVM.paginateWithIndex(index)
                                    }
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
                        }.onAppear {
                            //update scroll view value in scroll view reader
                            self.scrollViewReader = scrollViewReader
                        }
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
    
    //Wallet Transaction Cell
    @ViewBuilder
    private func walletTransactionCell(withDetails walletTransaction: WalletTransactionModel?) -> some View {
        let size = DeviceDimensions.width * 0.12
        let isDebit = Singleton.sharedInstance.generalFunctions.getUserID() ==  walletTransaction?.paidByUserID?.id
        let isPaymentSuccessfull = walletTransaction?.isPaymentSuccessful ?? false
        VStack(spacing: spacing) {
            Button {
                selectedWalletTransaction = walletTransaction
                selection = NavigationEnum.PaymentDetailsScreen.rawValue
            } label: {
                HStack(spacing: spacing) {
                    let toPaidUserName = (walletTransaction?.getPaidToUserModel?.name ?? "").capitalized
                    AvatarView(character: String(toPaidUserName.first ?? " "), size: size)
                    
                    VStack(spacing: 2) {
                        HStack(spacing: spacing) {
                            Text(toPaidUserName)
                                .fontCustom(.Medium, size: 16)
                                .foregroundColor(.blackColor)
                            
                            Spacer()
                            
                            let amount = Singleton.sharedInstance.generalFunctions.getCurrencySymbol() + (walletTransaction?.amount?.format() ?? "")
                            Text((isDebit ? "-" : "+") + " " + amount)
                                .fontCustom(.SemiBold, size: 16)
                                .foregroundColor(isDebit ? .redColor : .greenColor)
                        }
                        
                        HStack(spacing: spacing) {
                            Text(walletTransaction?.createdAt?.convertServerStringDate(toFormat: DateFormats.ddMMMYYYYathhmmaa) ?? "")
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
            }
            
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
