//
//  ContentView.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            Group {
                if Singleton.sharedInstance.generalFunctions.isUserLoggedIn() {
                    HomeScreen()
                } else {
                    LoginScreen()
                }
            }.navigationBarTitle("", displayMode: .inline)
        }.onAppear {
                UIApplication.shared.addTapGestureRecognizer()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
