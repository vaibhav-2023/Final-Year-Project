//
//  payment_appApp.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import SwiftUI

@main
struct payment_appApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject private var appEnvironmentObject = Singleton.sharedInstance.appEnvironmentObject
    
    var body: some Scene {
        WindowGroup {
            ZStack {
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
