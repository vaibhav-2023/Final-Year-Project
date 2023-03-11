//
//  VerifyOTPandFillDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import SwiftUI

//View for handling OTP Screen and Fill Details Screen in one View
struct VerifyOTPandFillDetailsScreen: View {
    
    //For Observing View Model
    @StateObject private var loginVM = LoginViewModel()
    
    //for showing otp screen or fill details screen
    @State private var showFillDetailsScreen: Bool = false
    
    private let countryCode: String
    private let mobileNumber: String
    
    //Constructor
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
    
    //Handle Status of Api's, when user OTP verifies and when fill details
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
    
    //steps to perform when uer has logged in
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
