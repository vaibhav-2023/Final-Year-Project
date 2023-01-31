//
//  ContentView.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path = [Data]()
    
    var body: some View {
//        if #available(iOS 16.0, *) {
//            NavigationStack(path: $path) {
//                content
//            }
//        } else {
            NavigationView {
                content
            }
//        }
    }
    
    var content: some View {
        Group {
            if Singleton.sharedInstance.generalFunctions.isUserLoggedIn() {
                HomeScreen()
            } else {
                LoginScreen()
            }
        }.navigationBarTitle("", displayMode: .inline)
            .onAppear {
                    UIApplication.shared.addTapGestureRecognizer()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
