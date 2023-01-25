//
//  AppTexts.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

class AppTexts {
    //common
    static let minute = "Minute"
    static let minutes = "Minutes"
    static let hour = "Hour"
    static let hours = "Hours"
    
    class AlertMessages {
        //common
        static let successWithExclamation = "Success!"
        static let errorWithExclamation = "Error!"
        static let invalidDetailsWithExclamation = "Invalid Details!"
        static let ok = "Ok"
        static let cancel = "Cancel"
        static let comingSoon = "Coming soon..."
        
        //network unreachable
        static let networkUnreachableWithExclamation = "Network Unreachable!"
        static let youAreNotConnectedToInternet = "You are not connected to Internet"
        static let tapToRetry = "Tap to Retry!"
        
        //session expired
        static let sessionExpiredWithExclamation = "Session Expired!"
        static let yourSessionHasExpiredPleaseLoginAgain = "Your Session has expired, PLease Login Again."
    }
}
