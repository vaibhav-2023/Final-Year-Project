//
//  OTPVerifyScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

//Used for verifying OTP created on 04/01/23
struct OTPVerifyScreen: View {
    
    //OTP View Model
    @StateObject private var otpViewModel = OTPTextFieldViewModel()
    
    //For Observing View Model sent from Previous Screen updated on 11/01/23
    @ObservedObject private var loginVM = LoginViewModel()
    
//    @State private var selection: Int? = nil
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //details received from previous screen
    private let countryCode: String
    private let mobileNumber: String
    
    //Constructor
    init(loginVM: LoginViewModel,
         countryCode: String,
         mobileNumber: String) {
        self.loginVM = loginVM
        self.countryCode = countryCode
        self.mobileNumber = mobileNumber
    }
    
    var body: some View {
        ZStack {
            
//            NavigationLink(destination: HomeScreen(), tag: NavigationEnum.HomeScreen.rawValue, selection: $selection) {
//                EmptyView()
//            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(AppTexts.verifyOTP)
                        .fontCustom(.SemiBold, size: 30)
                        .foregroundColor(.blackColor)
                    
                    Text(AppTexts.enterOTPSendToYourMobileNumber + " \(countryCode) \(mobileNumber)")
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    
                    HStack {
                        Spacer()
                        OTPTextField(viewModel: otpViewModel,
                                     backgroundColor: .lightGray)
                        Spacer()
                    }.padding(.top, spacing * 2)
                        .padding(.bottom, spacing)
                    
                    
                    MaxWidthButton(text: AppTexts.verify.uppercased(), fontEnum: .Medium) {
                        onVerifyOTPPressed()
                    }
                    
                    HStack(spacing: 4) {
                        Spacer()
                        Text(AppTexts.didNotReceiveOTPQuestionMark)
                            .fontCustom(.Regular, size: 16)
                            .foregroundColor(.blackColor)
                        
                        Button {
                            if !loginVM.isAnyApiBeingHit {
                                loginVM.resendOTPTo(mobileNumber: mobileNumber, withCountryCode: countryCode)
                            }
                        } label: {
                            Text(AppTexts.resendOTP)
                                .fontCustom(.Medium, size: 16)
                                .foregroundColor(.primaryColor)
                        }
                        Spacer()
                    }.padding(.top, padding)
                }.padding(padding)
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [.whiteColor, .lightBluishGrayColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        ).setNavigationBarTitle(title: AppTexts.verifyOTP)
    }
    
    //button on click updated on 05/01/23
    private func onVerifyOTPPressed() {
        if otpViewModel.otpField.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterOTP)
        } else if otpViewModel.otpField.count != 4 {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidOTP)
        } else {
//            selection = NavigationEnum.HomeScreen.rawValue
            if !loginVM.isAnyApiBeingHit {
                loginVM.verifyOTP(otpViewModel.otpField, sendToMobileNumber: mobileNumber, withCountryCode: countryCode)
            }
        }
    }
}

struct OTPVerifyScreen_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerifyScreen(loginVM: LoginViewModel(), countryCode: "", mobileNumber: "")
    }
}
