//
//  LoginFieldsOuterView.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct LoginFieldsOuterView<Content> : View where Content : View  {
    
    private let title: String
    private let spacing: CGFloat
    private let addFrameHeight: Bool
    private let addPadding: Bool
    private let content: Content
    private let cornerRadius: CGFloat = 5
    private let lineWidth: CGFloat = 1
    
    init(title: String = "",
         spacing: CGFloat = 5,
         addFrameHeight: Bool = true,
         addPadding: Bool = true,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.spacing = spacing
        self.addFrameHeight = addFrameHeight
        self.addPadding = addPadding
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            if (!title.isEmpty) {
                Text(title)
                    .fontCustom(.Medium, size: 16)
                    .foregroundColor(.blackColor)
            }
            
            content
                .if (addFrameHeight) { $0.frame(height: 20) }
                .if (addPadding) { $0.padding(12) }
                .background(Color.lightGray)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.darkGrayColor, lineWidth: lineWidth))
                .padding(lineWidth)
        }
    }
}

struct LoginFieldsOuterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFieldsOuterView(title: "Title") {
            VStack{}
        }
    }
}
