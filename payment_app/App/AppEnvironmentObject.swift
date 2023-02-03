//
//  AppEnvironmentObject.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//MARK: - AppEnvironmentObject
final class AppEnvironmentObject: ObservableObject {
    // suppose user log outs so send user to home screen
    @Published var changeContentView: Bool = false
    // for internet status, connected or not
    @Published var isConnectedToInternet: Bool = true
    //used to show add bank screen from ContentView
    var openFillBankDetailsScreen: Bool = false
}
