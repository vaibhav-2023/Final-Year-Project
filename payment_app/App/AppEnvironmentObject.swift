//
//  AppEnvironmentObject.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//A Single App Environment Object for complete app created on 31/12/22
//MARK: - AppEnvironmentObject
final class AppEnvironmentObject: ObservableObject {
    // suppose user log outs so send user to home screen
    @Published var changeContentView: Bool = false
    // for internet status, connected or not
    @Published var isConnectedToInternet: Bool = true
    //used to show add bank screen from ContentView added on created on 13/01/23
    var openFillBankDetailsScreen: Bool = false
    //used to show paymentDetails Screen from home screen  added on created on 13/01/23
    var walletTransactionDetails: WalletTransactionModel? = nil
}
