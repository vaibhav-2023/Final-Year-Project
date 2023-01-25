//
//  MyTextView.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI

struct MyTextView: View {
    
    private let placeHolder: String
    @Binding private var text: String
    private let fontEnum: FontEnum
    private let textSize: CGFloat
    private let textColor: Color
    private let keyboardType: UIKeyboardType
    private let autoCapitalization: UITextAutocapitalizationType
    //let onCommit:
    
    init(_ placeHolder: String,
         text: Binding<String>,
         fontEnum: FontEnum = .Regular,
         textSize: CGFloat = 15,
         textColor: Color = .blackColorForAllModes,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         autoCapitalization: UITextAutocapitalizationType = UITextAutocapitalizationType.sentences
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.fontEnum = fontEnum
        self.textSize = textSize
        self.textColor = textColor
        self.keyboardType = keyboardType
        self.autoCapitalization = autoCapitalization
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.bitterRegular(size: textSize))
                .foregroundColor(textColor)
                .accentColor(.primaryColor)
                .multilineTextAlignment(.leading)
                .frame(minHeight: 150, maxHeight: 150)
                .colorMultiply(Color.lightGray)
                .background(Color.lightGray)
                .cornerRadius(5)
            
            if text.isEmpty {
                Text(placeHolder)
                    .font(.bitterRegular(size: textSize))
                    .foregroundColor(.placeHolderColor)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }
        }
    }
}

struct MyTextView_Previews: PreviewProvider {
    static var previews: some View {
        MyTextView("", text: .constant(""))
    }
}
