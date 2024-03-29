//
//  KingfisherImageView.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI
import Kingfisher// as KF

//to show image from network, using Kingfisher Library
struct KingfisherImageView: View {
    
    private let urlString: String
    private let contentMode: SwiftUI.ContentMode
    // when aspect ratio increases height decreases
    private let aspectRatio: CGFloat?
    private let maxDimensionsGiven: Bool
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(urlString: String = "",
         contentMode: SwiftUI.ContentMode = SwiftUI.ContentMode.fill,
         aspectRatio: CGFloat? = nil,
         maxDimensionsGiven: Bool = false,
         width: CGFloat? = nil,
         height: CGFloat? = nil) {
        self.urlString = urlString
        self.contentMode = contentMode
        self.aspectRatio = aspectRatio
        self.maxDimensionsGiven = maxDimensionsGiven
        self.width = width
        self.height = height
    }
    
    var body: some View {
        KFImage.url(URL(string: urlString))
            .fade(duration: 1)
            .placeholder {
                //placeholder when image is not shown
                Image("placeholderImage")
                    .resizable()
                    .aspectRatio(aspectRatio, contentMode: contentMode)
                    .if (!maxDimensionsGiven) { $0.frame(width: width, height: height) }
                    .if (maxDimensionsGiven) { $0.frame(maxWidth: width, maxHeight: height) }
            }
            .cacheOriginalImage()
            .resizable()
            .aspectRatio(aspectRatio, contentMode: contentMode)
            .if (!maxDimensionsGiven) { $0.frame(width: width, height: height) }
            .if (maxDimensionsGiven) { $0.frame(maxWidth: width, maxHeight: height) }
    }
}

struct KingfisherImageView_Previews: PreviewProvider {
    static var previews: some View {
        KingfisherImageView()
    }
}
