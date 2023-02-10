//
//  FillUserDetailsScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct FillUserDetailsScreen: View {
    
    @ObservedObject private var loginVM = LoginViewModel()
    
    @State private var selection: Int? = nil
    
    @State private var name: String = ""
    @State private var email: String = ""
    
    @State private var pickerImageModel: ImageModel = ImageModel(sourceType: .camera)
    @State private var showImagePicker: Bool = false
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    init(loginVM: LoginViewModel) {
        self.loginVM = loginVM
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
    
    private func pickImageFrom(_ sourceType: UIImagePickerController.SourceType) {
        pickerImageModel.sourceType = sourceType
        showImagePicker = true
    }
    
    private func onSaveTapped() {
        if name.isEmpty {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterName)
        } else if !email.isEmpty && !email.isValidEmail {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.enterValidOTP)
        } else {
            loginVM.hitFillUserDetailsAPI(withName: name, email: email, andImageModel: pickerImageModel)
        }
    }
}

struct FillUserDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FillUserDetailsScreen(loginVM: LoginViewModel())
    }
}
