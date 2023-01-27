//
//  AvatarView.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct AvatarView: View {
    
    private let character: String
    private let width: CGFloat
    private let height: CGFloat
    
    init(character: String,
         size: CGFloat = DeviceDimensions.width * 0.12) {
        self.character = character
        self.width = size
        self.height = size
    }
    
    var body: some View {
        Text(character)
            .fontCustom(.Medium, size: 22)
            .foregroundColor(.whiteColorForAllModes)
            .frame(width: width, height: width)
            .background(Color.primaryColor)
            .clipShape(Circle())
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(character: "A")
    }
}
