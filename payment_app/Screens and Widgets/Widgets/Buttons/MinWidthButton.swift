//
//  MinWidthButton.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI

//Button which will cover all only required horizontal space
struct MinWidthButton: View {
    
    private let text: String
    private let fontEnum: FontEnum
    private let textSize: CGFloat
    private let textColor: Color
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let borderColor: Color
    @Binding private var isLoading: Bool
    private let onPressed: () -> Void
    
    init(text: String,
         fontEnum: FontEnum,
         textSize: CGFloat,
         textColor: Color = .whiteColorForAllModes,
         verticalPadding: CGFloat = 10,
         horizontalPadding: CGFloat = 10,
         backgroundColor: Color = .primaryColor,
         cornerRadius: CGFloat = 5,
         borderWidth: CGFloat = 0,
         borderColor: Color = .clear,
         isLoading: Binding<Bool> = .constant(false),
         onPressed: @escaping () -> Void = {
        print("No Action Given")
    }
    ) {
        self.text = text
        self.fontEnum = fontEnum
        self.textSize = textSize
        self.textColor = textColor
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self._isLoading = isLoading
        self.onPressed = onPressed
    }
    
    var body: some View {
        Button(action: {
            onPressed()
        }, label: {
            HStack(spacing: 6) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .frame(width: 14, height: 14)
                }
                
                Text(text)
                    .fontCustom(fontEnum, size: textSize)
                    .foregroundColor(textColor)
                    .lineLimit(1)
            }.padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .if (borderWidth > 0) { $0.overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth)) }
                .if (borderWidth > 0) { $0.padding(borderWidth) }
        })
    }
}

struct MinWidthButton_Previews: PreviewProvider {
    static var previews: some View {
        MinWidthButton(text: "Button", fontEnum: .Light, textSize: 15)
    }
}
