//
//  ImageView.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI

//image view with is system image option
struct ImageView: View {
    
    private let imageName: String
    private let isSystemImage: Bool
    
    init(imageName: String, isSystemImage: Bool) {
        self.imageName = imageName
        self.isSystemImage = isSystemImage
    }
    
    var body: some View {
        if isSystemImage {
            Image(systemName: imageName)
                .resizable()
        } else {
            Image(imageName)
                .resizable()
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageName: "", isSystemImage: true)
    }
}
