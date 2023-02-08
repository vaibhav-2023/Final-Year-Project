//
//  PaymentDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct PaymentDetailsScreen: View {
    
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    
    @StateObject private var walletVM = WalletTransactionsViewModel()
    
    private let walletTransactionsDetails: WalletTransactionModel?
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    init(walletTransactionsDetails: WalletTransactionModel?) {
        self.walletTransactionsDetails = walletTransactionsDetails
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                let isCredit = Singleton.sharedInstance.generalFunctions.getUserID() ==  walletVM.singleWalletTransaction?.paidByUserID?.id
                let isPaymentSuccessfull = walletVM.singleWalletTransaction?.isPaymentSuccessful ?? false
                
                VStack(spacing: spacing) {
                    HStack(alignment: .top) {
                        let name = (walletVM.singleWalletTransaction?.paidToUserID?.name ?? "").capitalized
                        VStack(alignment: .leading, spacing: spacing) {
                            Text(isCredit ? AppTexts.from : AppTexts.to)
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
                    
                    let mobileNumber = (walletVM.singleWalletTransaction?.paidToUserID?.numericCountryCode ?? "") + (walletVM.singleWalletTransaction?.paidToUserID?.phone ?? "")
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
                    let price: Double = walletVM.singleWalletTransaction?.amount ?? 0
                    HStack {
                        Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                            .foregroundColor(.blackColor)
                            .fontCustom(.Medium, size: 16)
                        
                        Text("\(price.format())")
                            .foregroundColor(.blackColor)
                            .fontCustom(.SemiBold, size: 40)
                    }.padding(.top, padding)
                    
                    let prefix = price > 1 ? AppTexts.ruppees : AppTexts.ruppee
                    textView((price.getNumberWords() + " " + prefix + " " + AppTexts.only).capitalized)
                        .padding(.bottom, padding)
                    
                    PaymentStatusView(isPaymentSuccessfull: isPaymentSuccessfull, isCredit: isCredit)
                        .padding(.top, padding)
                    
                    let date = walletVM.singleWalletTransaction?.createdAt?.convertServerStringDate(toFormat: DateFormats.ddMMMYYYYathhmmaa) ?? ""
                    textView("on \(date)")
                        .padding(.bottom, padding)
                    
                    VStack(spacing: padding) {
                        Text("\(AppTexts.transactionID):")
                            .foregroundColor(.blackColor)
                            .fontCustom(.Medium, size: 16)
                        
                        userDetails(title: AppTexts.from, userDetails: (walletVM.singleWalletTransaction?.paidByUserID?.name ?? "").capitalized)
                        userDetails(title: AppTexts.to, userDetails: (walletVM.singleWalletTransaction?.paidToUserID?.name ?? "").capitalized)
                    }
                    
                }.padding(padding)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .onAppear {
                if walletVM.singleWalletTransaction == nil, let walletTransactionsDetails {
                    walletVM.setWalletTransactionDetails(walletTransactionsDetails)
                }
                if let _ = appEnvironmentObject.walletTransactionDetails {
                    appEnvironmentObject.walletTransactionDetails = nil
                }
                walletVM.getWalletTransacionDetails(withID: walletTransactionsDetails?.id ?? "")
            }
    }
    
    @ViewBuilder
    private func textView(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.darkGrayColor)
            .fontCustom(.Regular, size: 13)
    }
    
    @ViewBuilder
    private func userDetails(title: String, userDetails: String) -> some View {
        CardView(backgroundColor: .lightBluishGrayColor) {
            VStack(alignment: .leading, spacing: spacing) {
                HStack {
                    Text(title + ":-")
                        .foregroundColor(.blackColor)
                        .fontCustom(.Regular, size: 15)
                    Spacer()
                }
                
                Text(userDetails)
                    .foregroundColor(.blackColor)
                    .fontCustom(.Medium, size: 16)
            }.padding(padding)
        }
    }
}

struct PaymentDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailsScreen(walletTransactionsDetails: nil)
    }
}
