//
//  MySecureField.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI

struct MySecureField: View {
    
    @State private var isTextHidden: Bool = true
    
    @Binding private var text: String
    
    private let placeHolder: String
    private let textSize: CGFloat
    
    init(_ placeHolder: String,
         text: Binding<String>,
         textSize: CGFloat = 15) {
        self.placeHolder = placeHolder
        self._text = text
        self.textSize = textSize
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if isTextHidden {
                SecureField(placeHolder, text: $text)
                    .font(.bitterRegular(size: textSize))
                    .foregroundColor(.blackColor)
                    .accentColor(.primaryColor)
            }else{
                TextField(placeHolder, text: $text)
                    .font(.bitterRegular(size: textSize))
                    .foregroundColor(.blackColor)
                    .accentColor(.primaryColor)
            }
            Button {
                isTextHidden.toggle()
            } label: {
                Image(systemName: isTextHidden ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.blackColor)
            }
        }
    }
}

struct MySecureField_Previews: PreviewProvider {
    static var previews: some View {
        MySecureField("", text: .constant(""), textSize: 15)
    }
}
