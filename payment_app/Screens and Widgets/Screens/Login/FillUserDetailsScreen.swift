//
//  FillUserDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

//Screen to get details from user created on 04/01/23
struct FillUserDetailsScreen: View {
    
    //For Observing View Model sent from Previous Screen updated on 11/01/23
    @ObservedObject private var loginVM = LoginViewModel()
    
    //variable used for navigation
    @State private var selection: Int? = nil
    
    //variables for storing details filled by user
    @State private var vpaNumber: String
    @State private var name: String = ""
    @State private var email: String = ""
    
    //variables used when picking image
    @State private var pickerImageModel: ImageModel = ImageModel(sourceType: .camera)
    @State private var showImagePicker: Bool = false
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //Constructor
    init(loginVM: LoginViewModel) {
        self.loginVM = loginVM
        self.vpaNumber = (loginVM.verifyOTPResponse?.data?.phone ?? "").removeString(AppTexts.atTheRateVPA)
    }
    
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
                    
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center, spacing: spacing) {
                            let isImageSeleted = pickerImageModel.uiImage != nil
                            ZStack(alignment: .bottomTrailing) {
                                let size = DeviceDimensions.width * 0.3
                                Group {
                                    if isImageSeleted {
                                        Image(uiImage: pickerImageModel.uiImage ?? UIImage())
                                            .resizable()
                                    } else {
                                        AvatarView(character: String(name.capitalized.first ?? "A"),
                                                   textSize: 35,
                                                   size: size)
                                    }
                                }.frame(width: size, height: size)
                                    .overlay(Circle().stroke(Color.blackColor))
                                    .clipShape(Circle())
                                
                                Button {
                                    Singleton.sharedInstance
                                        .alerts
                                        .actionSheetWith(title: AppTexts.AlertMessages.selectImageFrom,
                                                         message: nil,
                                                         firstDefaultButtonTitle: AppTexts.AlertMessages.camera,
                                                         firstDefaultButtonAction: { _ in
                                            pickImageFrom(.camera)
                                        },
                                                         secondDefaultButtonTitle: AppTexts.AlertMessages.photoLibrary,
                                                         secondDefaultButtonAction: { _ in
                                            pickImageFrom(.photoLibrary)
                                        })
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundColor(.blackColor)
                                        .padding(.trailing, size / 10)
                                }
                            }
                            
                            if isImageSeleted {
                                Button {
                                    pickerImageModel.uiImage = nil
                                } label: {
                                    Text(AppTexts.removeImage)
                                        .foregroundColor(.primaryColor)
                                        .fontCustom(.Medium, size: 16)
                                }
                            }
                        }
                        
                        Spacer()
                    }.padding(.top, spacing * 2)
                    
                    //added on 06/04/23
                    LoginFieldsOuterView(title: AppTexts.vpaNumber) {
                        
                        HStack(spacing: 0) {
                            MyTextField(AppTexts.TextFieldPlaceholders.enterVPANumber, text: $vpaNumber, keyboardType: .namePhonePad)
                            
                            Text(AppTexts.atTheRateVPA)
                                .fontCustom(.Regular, size: 15)
                        }
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.yourName) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterYourName, text: $name, keyboardType: .default)
                    }
                    
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
        ).setNavigationBarTitle(title: AppTexts.fillDetails)
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(imageModel: $pickerImageModel)
            }
    }
    
    //button to pick image from camera or photolibrary
    private func pickImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        pickerImageModel.sourceType = sourceType
        showImagePicker = true
    }
    
    //button on click updated on 05/01/23
    private func onSaveTapped() {
        let vpaString = vpaNumber.trim() + AppTexts.atTheRateVPA
        if vpaString.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterVPA)
        } else if !vpaString.isValidVPA {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidVPA)
        } else if name.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterName)
        } else if !email.isEmpty && !email.isValidEmail {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidOTP)
        } else {
            loginVM.hitFillUserDetailsAPI(withVPANumber: vpaString, name: name, email: email, andImageModel: pickerImageModel)
        }
    }
}

struct FillUserDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FillUserDetailsScreen(loginVM: LoginViewModel())
    }
}
