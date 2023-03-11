//
//  CardView.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI

//Card View used to create a crad view with dynamic content in it
struct CardView<Content> : View where Content : View {
    
    //Variables to hold values
    private let useMaxWidth: Bool
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let shadowColor: Color
    private let shadowOpacity: CGFloat
    private let radius: CGFloat
    private let x: CGFloat
    private let y: CGFloat
    private let content: Content
    
    //Constructor
    init(useMaxWidth: Bool = true,
         backgroundColor: Color = .whiteColor,
         cornerRadius: CGFloat = 8,
         shadowColor: Color = .darkGrayColor,
         shadowOpacity: CGFloat = 1.25,
         radius: CGFloat = 1.25,
         x: CGFloat = 0.5,
         y: CGFloat = 0.5,
        @ViewBuilder content: () -> Content) {
        self.useMaxWidth = useMaxWidth
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.radius = radius
        self.x = x
        self.y = y
        self.content = content()
    }
    
    public var body: some View {
        content
            .if (useMaxWidth) { $0.frame(maxWidth: .infinity) }
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .if (radius > 0) { $0.shadow(color: shadowColor.opacity(shadowOpacity), radius: radius, x: x, y: y) }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("Hello")
        }
    }
}
