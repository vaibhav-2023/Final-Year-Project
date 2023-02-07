//
//  MyTextField.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI
import Combine

struct MyTextField: View {
    
    private let placeHolder: String
    @Binding private var text: String
    private let fontEnum: FontEnum
    private let textSize: CGFloat
    private let textColor: Color
    private let maxLength: Int?
    private let keyboardType: UIKeyboardType
    private let autoCapitalization: UITextAutocapitalizationType
    private let fixedSize: Bool
    private let onEditingChanged: (Bool) -> Void
    //let onCommit:
    
    init(_ placeHolder: String = "",
         text: Binding<String> = .constant(""),
         fontEnum: FontEnum = .Regular,
         textSize: CGFloat = 15,
         textColor: Color = .blackColor,
         maxLength: Int? = nil,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         autoCapitalization: UITextAutocapitalizationType = UITextAutocapitalizationType.none,
         fixedSize: Bool = false,
         onEditingChanged: @escaping (Bool) -> Void = { _ in
        
    }
//         onCommit: {
//            // Called when the user tap the return button
//            // see `onCommit` oncha TextField initializer.
//            UIApplication.shared.endEditing()
//        }
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.fontEnum = fontEnum
        self.textSize = textSize
        self.textColor = textColor
        if maxLength != nil {
            self.maxLength = maxLength
        } else if keyboardType == .phonePad {
            self.maxLength = 10
        } else {
            self.maxLength = nil
        }
        self.keyboardType = keyboardType
        self.autoCapitalization = autoCapitalization
        self.fixedSize = fixedSize
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeHolder)
                    .foregroundColor(.placeHolderColor)
                    .font(.bitterRegular(size: textSize))
            }
            
            TextField("", text: $text, onEditingChanged: onEditingChanged)
                .keyboardType(keyboardType)
                .autocapitalization(autoCapitalization)
                .onReceive(Just(text)) { newValue in
                    onReceive(newValue: newValue)
                }
                //.fontCustom(fontEnum, size: textSize)
                .font(.bitterRegular(size: textSize))
                .foregroundColor(textColor)
                .accentColor(.primaryColor)
                .if (fixedSize) { $0.fixedSize() }
        }
    }
    
    private func onReceive(newValue: String) {
        switch keyboardType {
        case .numberPad, .phonePad:
            let filtered = newValue.filter { "0123456789".contains($0) }
            updateValue(withFiltered: filtered, andNewValue: newValue)
        default:
            updateValue(withFiltered: newValue, andNewValue: newValue)
            break
        }
    }
    
    private func updateValue(withFiltered filtered: String, andNewValue newValue: String) {
        if let maxLength {
            if filtered.count <= maxLength {
                if filtered != newValue {
                    text = filtered
                }
            }else{
                text = "\(text.prefix(maxLength))"
            }
        } else {
            if filtered != newValue {
                text = filtered
            }
        }
    }
}

struct MyTextField_Previews: PreviewProvider {
    static var previews: some View {
        MyTextField()
    }
}

