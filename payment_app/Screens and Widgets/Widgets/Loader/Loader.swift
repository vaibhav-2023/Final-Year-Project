//
//  Loader.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

//loader of the app, to show when view is loading
struct Loader: View {
    
    @Binding private var isPresenting: Bool
    
    init(isPresenting: Binding<Bool>) {
        self._isPresenting = isPresenting
    }
    
    var body: some View {
        ZStack {
            if isPresenting {
                LargeProgressView()
                    .padding(24)
                    .background(BlurView(style: .systemMaterial))
                    .cornerRadius(10)
                    .transition(.asymmetric(insertion: .scale, removal: .scale))
            }
        }.animation(Animation.easeIn, value: isPresenting)
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader(isPresenting: .constant(false))
    }
}
