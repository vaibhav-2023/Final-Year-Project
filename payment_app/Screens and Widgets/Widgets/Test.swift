//
//  Test.swift
//  payment_app
//
//  Created by MacBook PRO on 18/01/23.
//

import SwiftUI

struct Test: View {
    var body: some View {
        let size = DeviceDimensions.width * 0.7
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Spacer()
                }
                Spacer()
            }.background(Color.lightPrimaryColor)
            
            Rectangle()
                .foregroundColor(Color.black.opacity(0.5))
                .mask(Window(size: CGSize(width: size, height: size)).fill(style: FillStyle(eoFill: true)))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white, lineWidth: 3)
                    .frame(width: size, height: size))
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
struct Window: Shape {
    let size: CGSize
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)

        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        path.addRect(CGRect(origin: origin, size: size))
        return path
    }
}
