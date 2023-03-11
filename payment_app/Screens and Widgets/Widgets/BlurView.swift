//
//  BlurView.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI

//Used for getting Blur Effect from UIKit and use it in SwiftUI Views
struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    private let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LargeProgressView()
                .padding(24)
            //.background(Color.placeHolderColor)
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(10)
        }
    }
}
