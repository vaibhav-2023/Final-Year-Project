//
//  FillUserDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct FillUserDetailsScreen: View {
    
    @StateObject private var profileVM = ProfileViewModel()
    
    @State private var selection: Int? = nil
    
    @State private var name: String = ""
    @State private var email: String = ""
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            NavigationLink(destination: HomeScreen(), tag: NavigationEnum.HomeScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(AppTexts.enterYourDetails)
                        .fontCustom(.SemiBold, size: 30)
                        .foregroundColor(.blackColor)
                    
                    Text(AppTexts.tellUsAboutYourself + "...")
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    LoginFieldsOuterView(title: AppTexts.yourName) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterYourName, text: $name, keyboardType: .default)
                    }.padding(.top, spacing * 2)
                    
                    LoginFieldsOuterView(title: AppTexts.yourEmail + "(\(AppTexts.optional))") {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterYourEmail, text: $email, keyboardType: .emailAddress)
                    }.padding(.bottom, spacing)
                    
                    
                    MaxWidthButton(text: AppTexts.save.uppercased(), fontEnum: .Medium) {
                        onSaveTapped()
                    }
                }.padding(padding)
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [.whiteColor, .lightBluishGrayColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
            .showLoader(isPresenting: .constant(profileVM.isAnyApiBeingHit))
            .onReceive(profileVM.$fillDetailsAS) { fillDetailsAS in
                if fillDetailsAS == .ApiHit {
                    //selection = NavigationEnum.OTPVerify.rawValue
                }
            }
    }
    
    private func onSaveTapped() {
        if name.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterName)
        } else if !email.isEmpty && !email.isValidEmail {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidOTP)
        } else {
            profileVM.hitFillUserDetailsAPI(withName: name, andEmail: email)
        }
    }
}

struct FillUserDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FillUserDetailsScreen()
    }
}
