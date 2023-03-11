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
    
    private var content: some View {
        Group {
            //if user is logged in(condition added on 04/01/23)
            if Singleton.sharedInstance.generalFunctions.isUserLoggedIn() {
                //if user is logged and details of banks are not filled, open fill bank details screen(condition added on 04/01/23)
                if Singleton.sharedInstance.appEnvironmentObject.openFillBankDetailsScreen {
                    FillBankDetailsScreen(isUserFromContentView: true)
                        .onAppear {
                            Singleton.sharedInstance.appEnvironmentObject.openFillBankDetailsScreen = false
                        }
                } else {
                    //if user is logged and details of banks are filled, open home screen
                    HomeScreen()
                }
            } else {
                //if user is not logged in open login screen
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
