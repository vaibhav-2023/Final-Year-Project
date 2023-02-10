//
//  AvatarView.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct AvatarView: View {
    
    private let character: String
    private let textSize: CGFloat
    private let width: CGFloat
    private let height: CGFloat
    private let strokeColor: Color
    private let lineWidth: CGFloat
    
    init(character: String,
         textSize: CGFloat = 22,
         size: CGFloat = DeviceDimensions.width * 0.12,
         strokeColor: Color = Color.clear,
         lineWidth: CGFloat = 0) {
        self.character = character
        self.textSize = textSize
        self.width = size
        self.height = size
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        Text(character)
            .fontCustom(.Medium, size: textSize)
            .foregroundColor(.whiteColorForAllModes)
            .frame(width: width, height: width)
            .background(Color.primaryColor)
            .clipShape(Circle())
            .if (lineWidth > 0) { $0.overlay(Circle().stroke(strokeColor, lineWidth: lineWidth)).padding(lineWidth) }
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(character: "A")
    }
}
