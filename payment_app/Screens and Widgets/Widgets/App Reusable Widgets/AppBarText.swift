//
//  AppBarText.swift
//  payment_app
//
//  Created by MacBook PRO on 09/01/23.
//

import SwiftUI

struct AppBarText: View {
    private let title: String
    private let textSize: CGFloat
    
    init(title: String,
         textSize: CGFloat = 18) {
        self.title = title
        self.textSize = textSize
    }
    
    var body: some View {
        Text(title)
            .fontCustom(.Medium, size: textSize)
            .foregroundColor(.primaryColor)
    }
}

struct AppBarText_Previews: PreviewProvider {
    static var previews: some View {
        AppBarText(title: "", textSize: 18)
    }
}
