//
//  IconButton.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI

//Button with Icon in it's Content View
struct IconButton: View {
    
    private let imageName: String
    private let isSystemImage: Bool
    private let foregroundColor: Color
    private let width: CGFloat
    private let height: CGFloat
    private let onPressed: () -> Void
    
    init(imageName: String = "bell",
         isSystemImage: Bool = true,
         foregroundColor: Color = .whiteColor,
         width: CGFloat = 20,
         height: CGFloat = 20,
         onPressed: @escaping () -> Void = {
             print("No Action Given")
         }) {
        self.imageName = imageName
        self.isSystemImage = isSystemImage
        self.foregroundColor = foregroundColor
        self.width = width
        self.height = height
        self.onPressed = onPressed
    }
    
    var body: some View {
        Button(action: {
            onPressed()
        }, label: {
            ImageView(imageName: imageName, isSystemImage: isSystemImage)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(foregroundColor)
                .frame(width: height, height: width)
        })
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton()
    }
}
