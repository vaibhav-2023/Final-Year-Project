//
//  AvatarView.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI
import Kingfisher

//Avatar View, which will show first letter of name or the profile pic of the user
struct AvatarView: View {
    
    private let imageURL: String
    private let character: String
    private let textSize: CGFloat
    private let width: CGFloat
    private let height: CGFloat
    private let strokeColor: Color
    private let lineWidth: CGFloat
    
    init(imageURL: String = "",
         character: String,
         textSize: CGFloat = 22,
         size: CGFloat = DeviceDimensions.width * 0.12,
         strokeColor: Color = Color.clear,
         lineWidth: CGFloat = 0) {
        self.imageURL = imageURL
        self.character = character
        self.textSize = textSize
        self.width = size
        self.height = size
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        Group {
            if imageURL.isEmpty || imageURL == "user/default.jpg" {
                characterText
            } else {
                KFImage.url(URL(string: AppURLs.getImageURL() + imageURL))
                    .fade(duration: 1)
                    .placeholder {
                        //placeholder when image is not shown
                        characterText
                    }
                    .cacheOriginalImage()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
            }
        }.frame(width: width, height: width)
            .background(Color.primaryColor)
            .clipShape(Circle())
            .if (lineWidth > 0) { $0.overlay(Circle().stroke(strokeColor, lineWidth: lineWidth)).padding(lineWidth) }
    }
    
    private var characterText: some View {
        Text(character)
            .fontCustom(.Medium, size: textSize)
            .foregroundColor(.whiteColorForAllModes)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(character: "A")
    }
}
