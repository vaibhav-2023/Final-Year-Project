//
//  CardView.swift
//  gulati_handlom
//
//  Created by MacBook Pro on 03/10/21.
//

import SwiftUI

struct CardView<Content> : View where Content : View {
    
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let shadowColor: Color
    private let radius: CGFloat
    private let x: CGFloat
    private let y: CGFloat
    private let content: Content
    
    init(backgroundColor: Color = .whiteColor,
         cornerRadius: CGFloat = 8,
         shadowColor: Color = .darkGrayColor,
         radius: CGFloat = 1.25,
         x: CGFloat = 0.5,
         y: CGFloat = 0.5,
        @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.radius = radius
        self.x = x
        self.y = y
        self.content = content()
    }
    
    public var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .if (radius > 0) { $0.shadow(color: shadowColor, radius: radius, x: x, y: y) }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("Hello")
        }
    }
}
