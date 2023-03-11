//
//  EmptyListView.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import SwiftUI

//This View is shown when no data is found, or when list is empty
struct EmptyListView: View {
    
    //image to show and text to show under image
    private let imageName: String
    private let text: String
    
    private let dimensions: CGFloat = 200//UIScreen.main.bounds.size.width - 2
    
    init (imageName: String = "noDataImage",
          text: String = AppTexts.noDataAvailable) {
        self.imageName = imageName
        self.text = text
    }
    
    var body: some View {
        
        VStack{
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    Image(imageName)
                        // .resizable()
                        // .aspectRatio(contentMode: .fit)
                        // .frame(width: dimensions, height: dimensions, alignment: .center)
                    
                    Text(text)
                        .fontCustom(.Regular, size: 18)
                        .foregroundColor(.darkGrayColor)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
