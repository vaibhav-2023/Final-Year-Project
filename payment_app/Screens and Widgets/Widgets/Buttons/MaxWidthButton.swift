//
//  MaxWidthButton.swift
//  gulati_handlom
//
//  Created by MacBook Pro on 01/10/21.
//

import SwiftUI

struct MaxWidthButton: View {
    
    private let text: String
    private let fontEnum: FontEnum
    private let textSize: CGFloat
    private let textColor: Color
    private let verticalPadding: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let borderColor: Color
    @Binding private var isLoading: Bool
    private let onPressed: () -> Void
    
    init(text: String,
         fontEnum: FontEnum,
         textSize: CGFloat = 18,
         textColor: Color = .whiteColorForAllModes,
         verticalPadding: CGFloat = 8,
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
            HStack(alignment: .center, spacing: 8, content: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                    //.resizable()
                        .frame(width: 14, height: 14)
                }
                
                Text(text)
                    .fontCustom(fontEnum, size: textSize)
                    .foregroundColor(textColor)
            }).padding(.vertical, verticalPadding)
                .frame(maxWidth:.infinity)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .if (borderWidth > 0) { $0.overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth)) }
                .if (borderWidth > 0) { $0.padding(borderWidth) }
        })
    }
}

struct MaxWidthButton_Previews: PreviewProvider {
    static var previews: some View {
        MaxWidthButton(text: "Button", fontEnum: .Medium)
    }
}
