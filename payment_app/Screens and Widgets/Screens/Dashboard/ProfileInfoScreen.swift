//
//  ProfileInfoScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 09/01/23.
//

import SwiftUI

struct ProfileInfoScreen: View {
    
    //For Handling View Model
    @StateObject private var profileVM = ProfileViewModel()
    
    //variables for storing details filled by user
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var countryCode: String = Singleton.sharedInstance.generalFunctions.getNumericCountryCodeOfDevice()
    @State private var mobileNumber: String = ""
    
    //variables for picking image from deevice
    @State private var pickerImageModel: ImageModel = ImageModel(sourceType: .camera)
    @State private var showImagePicker: Bool = false
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(AppTexts.yourDetails)
                        .fontCustom(.SemiBold, size: 30)
                        .foregroundColor(.blackColor)
                    
//                    Text(AppTexts.tellUsAboutYourself + "...")
//                        .fontCustom(.Medium, size: 16)
//                        .foregroundColor(.blackColor)
                    
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center, spacing: spacing) {
                            let isImageSelected = pickerImageModel.uiImage != nil
                            ZStack(alignment: .bottomTrailing) {
                                let size = DeviceDimensions.width * 0.3
                                Group {
                                    if isImageSelected {
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
                                
//                                Button {
//                                    Singleton.sharedInstance
//                                        .alerts
//                                        .actionSheetWith(title: AppTexts.AlertMessages.selectImageFrom,
//                                                         message: nil,
//                                                         firstDefaultButtonTitle: AppTexts.AlertMessages.camera,
//                                                         firstDefaultButtonAction: { _ in
//                                            pickImageFrom(.camera)
//                                        },
//                                                         secondDefaultButtonTitle: AppTexts.AlertMessages.photoLibrary,
//                                                         secondDefaultButtonAction: { _ in
//                                            pickImageFrom(.photoLibrary)
//                                        })
//                                } label: {
//                                    Image(systemName: "square.and.pencil")
//                                        .foregroundColor(.blackColor)
//                                        .padding(.trailing, size / 10)
//                                }
                            }
                            
                            if isImageSelected {
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
                    
                    LoginFieldsOuterView(title: AppTexts.name) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterYourName, text: $name, keyboardType: .default)
                    }
                    
                    LoginFieldsOuterView(title: AppTexts.email) {
                        MyTextField(AppTexts.TextFieldPlaceholders.enterYourEmail, text: $email, keyboardType: .emailAddress)
                    }
                    
                    VStack(alignment: .leading, spacing: spacing/2) {
                        Text(AppTexts.mobileNumber)
                            .fontCustom(.Medium, size: 16)
                            .foregroundColor(.blackColor)
                        
                        HStack {
                            LoginFieldsOuterView {
                                Text(countryCode)
                                    .fontCustom(.Regular, size: 15)
                                    .foregroundColor(.blackColor)
                            }
                            LoginFieldsOuterView {
                                MyTextField(AppTexts.TextFieldPlaceholders.enterMobileNumber, text: $mobileNumber, maxLength: 10, keyboardType: .numberPad)
                            }
                        }.padding(.bottom, spacing)
                    }
                    
                    
                    //                MaxWidthButton(text: AppTexts.save.uppercased(), fontEnum: .Medium) {
                    //                    onSaveTapped()
                    //                }
                    //            }.padding(padding)
                }.padding(padding)
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [.whiteColor, .lightBluishGrayColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        ).setNavigationBarTitle(title: AppTexts.yourDetails)
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(imageModel: $pickerImageModel)
            }
            .onAppear {
                //on open screen set data of user in the text fields
                let userModel = Singleton.sharedInstance.generalFunctions.getUserModel()
                name = userModel?.name ?? ""
                email = userModel?.email ?? ""
                countryCode = userModel?.numericCountryCode ?? ""
                mobileNumber = userModel?.phone ?? ""
            }
    }
    
    //button to pick image from camera or photolibrary
    private func pickImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        pickerImageModel.sourceType = sourceType
        showImagePicker = true
    }
    
    //on button tap
    private func onSaveTapped() {
        if name.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterName)
        } else if !email.isEmpty && !email.isValidEmail {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidOTP)
        } else {
            profileVM.hitFillUserDetailsAPI(withName: name, email: email, andImageModel: pickerImageModel)
        }
    }
}

struct ProfileInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoScreen()
    }
}
