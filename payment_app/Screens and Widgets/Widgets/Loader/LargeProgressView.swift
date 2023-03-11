//
//  Loader.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

//Large Activity Indicator created using UIKit
struct LargeProgressView: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<LargeProgressView>) -> UIActivityIndicatorView {
        
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.startAnimating()
        
        return progressView
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LargeProgressView>) {
    }
}

struct LargeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LargeProgressView()
    }
}
