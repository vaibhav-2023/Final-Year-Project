//
//  MyTextView.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI
import Combine

//Custom Text View
struct MyTextView: View {
    
    private let placeHolder: String
    @Binding private var text: String
    private let isAdjustableTV: Bool
    @Binding private var adjustableTVHeight: CGFloat
    private let adjustableTVMaxHeight: CGFloat
    private let fontEnum: FontEnum
    private let textSize: CGFloat
    private let textColor: Color
    private let maxLength: Int?
    private let keyboardType: UIKeyboardType
    private let autoCapitalization: UITextAutocapitalizationType
    private let accentColor: Color
    //let onCommit:
    
    init(_ placeHolder: String,
         text: Binding<String>,
         isAdjustableTV: Bool = false,
         adjustableTVHeight: Binding<CGFloat> = .constant(20),
         adjustableTVMaxHeight: CGFloat = 100,
         fontEnum: FontEnum = .Regular,
         textSize: CGFloat = 15,
         textColor: Color = .blackColorForAllModes,
         maxLength: Int? = nil,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         autoCapitalization: UITextAutocapitalizationType = UITextAutocapitalizationType.sentences,
         accentColor: Color = .primaryColor
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.isAdjustableTV = isAdjustableTV
        self._adjustableTVHeight = adjustableTVHeight
        self.adjustableTVMaxHeight = adjustableTVMaxHeight
        self.fontEnum = fontEnum
        self.textSize = textSize
        self.textColor = textColor
        self.maxLength = maxLength
        self.keyboardType = keyboardType
        self.autoCapitalization = autoCapitalization
        self.accentColor = accentColor
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {

            let showPlaceholder = text.isEmpty
            if showPlaceholder {
                Text(placeHolder)
                    .font(.bitterRegular(size: textSize))
                    .foregroundColor(.placeHolderColor)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }
            
            Group {
                if !isAdjustableTV {
                    TextEditor(text: $text)
                        .font(.bitterRegular(size: textSize))
                        .foregroundColor(textColor)
                        .accentColor(.primaryColor)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 150, maxHeight: 150)
                        .colorMultiply(Color.lightGray)
                        .background(Color.lightGray)
                        .cornerRadius(5)
                } else {
                    AdjustableHeightTextView(height: $adjustableTVHeight,
                                             maxheight: adjustableTVMaxHeight,
                                             text: $text,
                                             fontEnum: fontEnum,
                                             textSize: textSize,
                                             textColor: textColor,
                                             keyboardType: keyboardType,
                                             autoCapitalization: autoCapitalization,
                                             cursorColor: accentColor)
                    .frame(height: adjustableTVHeight)
                }
            }.opacity(showPlaceholder ? 0.5 : 1)
        }.onReceive(Just(text)) { newValue in
            onReceive(newValue: newValue)
        }
    }
    
    private func onReceive(newValue: String) {
        if let maxLength {
            text = "\(text.prefix(maxLength))"
        }
    }
}

struct MyTextView_Previews: PreviewProvider {
    static var previews: some View {
        MyTextView("", text: .constant(""))
    }
}
