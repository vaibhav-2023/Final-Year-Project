//
//  payment_appApp.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI

@main
struct payment_appApp: App {
    
    //set up app delegate with app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //set up app environment object with app
    @ObservedObject private var appEnvironmentObject = Singleton.sharedInstance.appEnvironmentObject
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                //handle content view changes acc. to app environment object's ContentView
                if appEnvironmentObject.changeContentView {
                    ContentView()
                        .environmentObject(appEnvironmentObject)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                } else {
                    ContentView()
                        .environmentObject(appEnvironmentObject)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
            }.animation(Animation.easeIn, value: appEnvironmentObject.changeContentView)
        }
    }
}
