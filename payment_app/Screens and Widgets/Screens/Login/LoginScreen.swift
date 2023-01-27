//
//  LoginScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject private var loginVM = LoginViewModel()
    
    @State private var selection: Int? = nil
    
    @State private var countryCode: String = "91"
    @State private var mobileNumber: String = ""
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            NavigationLink(destination: OTPVerifyScreen(countryCode: countryCode, mobileNumber: mobileNumber), tag: NavigationEnum.OTPVerify.rawValue, selection: $selection) {
                EmptyView()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(AppTexts.mobileNumber)
                        .fontCustom(.SemiBold, size: 30)
                        .foregroundColor(.blackColor)
                    
                    Text(AppTexts.enterYourMobileNumberToContinue)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    HStack {
                        LoginFieldsOuterView {
                            Text(countryCode)
                                .fontCustom(.Regular, size: 15)
                                .foregroundColor(.blackColor)
                        }
                        LoginFieldsOuterView {
                            MyTextField(AppTexts.TextFieldPlaceholders.enterMobileNumber, text: $mobileNumber, maxLength: 10, keyboardType: .phonePad)
                        }
                    }.padding(.top, spacing * 2)
                        .padding(.bottom, spacing)
                    
                    
                    MaxWidthButton(text: AppTexts.login.uppercased(), fontEnum: .Medium) {
                        onLoginPressed()
                    }
                }.padding(padding)
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [.whiteColor, .lightBluishGrayColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
            .showLoader(isPresenting: .constant(loginVM.isAnyApiBeingHit))
            .onReceive(loginVM.$loginAS) { loginAS in
                if (loginAS == .OTPSent) {
                    selection = NavigationEnum.OTPVerify.rawValue
                }
            }
    }
    
    
    private func onLoginPressed() {
        if mobileNumber.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterMobileNumber)
        } else if !mobileNumber.isValidPhone {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidMobileNumber)
        } else {
            loginVM.sendOTPTo(mobileNumber: mobileNumber, withCountryCode: countryCode)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
