//
//  AdjustableHeightTextView.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct AdjustableHeightTextView: UIViewRepresentable {

    @Binding private var height: CGFloat
    private let maxheight: CGFloat
    @Binding private var text: String
    private let fontEnum: FontEnum
    private let textSize: CGFloat
    private let textColor: Color
    private let keyboardType: UIKeyboardType
    private let autoCapitalization: UITextAutocapitalizationType
    
    init(height: Binding<CGFloat>,
         maxheight: CGFloat,
         text: Binding<String>,
         fontEnum: FontEnum,
         textSize: CGFloat,
         textColor: Color,
         keyboardType: UIKeyboardType,
         autoCapitalization: UITextAutocapitalizationType) {
        self._height = height
        self.maxheight = maxheight
        self._text = text
        self.fontEnum = fontEnum
        self.textSize = textSize
        self.textColor = textColor
        self.keyboardType = keyboardType
        self.autoCapitalization = autoCapitalization
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.text = text
        textView.textColor = UIColor(textColor)
        textView.keyboardType = keyboardType
        textView.autocapitalizationType = autoCapitalization
        
        switch fontEnum {
        case .Light:
            textView.font = UIFont.bitterLight(size: textSize)
        case .Regular:
            textView.font = UIFont.bitterRegular(size: textSize)
        case .Medium:
            textView.font = UIFont.bitterMedium(size: textSize)
        case .SemiBold:
            textView.font = UIFont.bitterSemiBold(size: textSize)
        case .Bold:
            textView.font = UIFont.bitterBold(size: textSize)
        }
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
    }

    class Coordinator: NSObject, UITextViewDelegate {
        private let textView: AdjustableHeightTextView
        init(_ textView: AdjustableHeightTextView) {
            self.textView = textView
        }

        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.textView.text = textView.text
                let contentSize = textView.sizeThatFits(textView.bounds.size)
                if contentSize.height >= self.textView.maxheight {
                    textView.isScrollEnabled = true
                    self.textView.height = self.textView.maxheight
                }else{
                    textView.isScrollEnabled = false
                    self.textView.height = contentSize.height
                }
            }
        }
    }
}

//struct AdjustableHeightTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustableHeightTextView(height: .constant(50), maxheight: 100)
//    }
//}
