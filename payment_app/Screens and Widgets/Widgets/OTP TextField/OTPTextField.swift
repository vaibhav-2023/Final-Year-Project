//
//  OTPTextField.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI
import Combine

//OTP Text Field created using following links
//https://stackoverflow.com/questions/69025986/creating-otp-page-for-swiftui-using-textfield
//https://imthath.medium.com/swiftui-passcode-field-for-otp-and-pin-entry-b61ba663dc31
struct OTPTextField: View {
    
    @ObservedObject private var viewModel: OTPTextFieldViewModel
    
    @State private var isFocused = false
    
    private let backgroundColor: Color
    
    private let textBoxWidth = UIScreen.main.bounds.width / 8
    private let textBoxHeight = UIScreen.main.bounds.width / 8
    private let spaceBetweenBoxes: CGFloat = 8
    private let paddingOfBox: CGFloat = 0
    private var textFieldOriginalWidth: CGFloat {
        (textBoxWidth * 4) + (spaceBetweenBoxes * 3) + ((paddingOfBox * 2) * 3)
    }
    
    init(viewModel: OTPTextFieldViewModel, backgroundColor: Color) {
        self.viewModel = viewModel
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                HStack (spacing: spaceBetweenBoxes) {
                    otpText(text: viewModel.otp1)
                    otpText(text: viewModel.otp2)
                    otpText(text: viewModel.otp3)
                    otpText(text: viewModel.otp4)
                }
                
                TextField("", text: $viewModel.otpField)
                    .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                    .disabled(viewModel.isTextFieldDisabled)
                    .keyboardType(.phonePad)
                    .foregroundColor(.clear)
                    .accentColor(.clear)
                    .background(Color.clear)
                    .onReceive(Just(viewModel.otpField)) { newValue in
                        //enter only required characters in text field
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        let maxLength = 4
                        if(filtered.count <= maxLength){
                            if filtered != newValue {
                                viewModel.otpField = filtered
                            }
                        }else{
                            viewModel.otpField = "\(viewModel.otpField.prefix(maxLength))"
                        }
                    }
            }
        }
    }
    
    //Create Single OTP Text Field
    @ViewBuilder
    private func otpText(text: String) -> some View {
        Text(text)
                .fontCustom(.Medium, size: 24)
                .foregroundColor(.blackColorForAllModes)
                .frame(width: textBoxWidth, height: textBoxHeight)
                .padding(paddingOfBox)
                .background(backgroundColor)
//                .overlay(VStack{
//                    Spacer()
//                    Rectangle()
//                        .frame(height: 1)
//                        //.offset(y: -(textBoxHeight / 6))
//                })
             .cornerRadius(5)
                 .overlay(RoundedRectangle(cornerRadius: 5) .stroke(Color.darkGrayColor, lineWidth: 1))
    }
}

struct OTPTextField_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextField(viewModel: OTPTextFieldViewModel(), backgroundColor: .whiteColor)
    }
}
