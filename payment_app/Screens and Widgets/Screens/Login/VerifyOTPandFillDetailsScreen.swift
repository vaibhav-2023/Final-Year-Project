//
//  VerifyOTPandFillDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import SwiftUI

struct VerifyOTPandFillDetailsScreen: View {
    
    @StateObject private var loginVM = LoginViewModel()
    
    @State private var showFillDetailsScreen: Bool = false
    
    private let countryCode: String
    private let mobileNumber: String
    
    init(countryCode: String,
         mobileNumber: String) {
        self.countryCode = countryCode
        self.mobileNumber = mobileNumber
    }
    
    var body: some View {
        ZStack {
            if !showFillDetailsScreen {
                OTPVerifyScreen(loginVM: loginVM,
                                countryCode: countryCode,
                                mobileNumber: mobileNumber)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            } else {
                FillUserDetailsScreen(loginVM: loginVM)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }.animation(Animation.easeIn, value: showFillDetailsScreen)
            .showLoader(isPresenting: .constant(loginVM.isAnyApiBeingHit))
            .onReceive(loginVM.$loginAS) { apiStatus in
                handleStatus(apiStatus)
            }.onReceive(loginVM.$fillDetailsAS) { apiStatus in
                handleStatus(apiStatus)
            }
    }
    
    private func handleStatus(_ apiStatus: LoginApiStatus) {
        switch apiStatus {
        case .FillBankDetails:
            Singleton.sharedInstance.appEnvironmentObject.openFillBankDetailsScreen = true
            userLoggedIn()
        case .FillDetails:
            showFillDetailsScreen = true
        case .LoggedIn:
            userLoggedIn()
        default:
            break
        }
    }
    
    private func userLoggedIn() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
        Singleton.sharedInstance.appEnvironmentObject.changeContentView.toggle()
    }
}

struct VerifyOTPandFillDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        VerifyOTPandFillDetailsScreen(countryCode: "", mobileNumber: "")
    }
}
