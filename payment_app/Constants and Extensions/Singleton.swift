//
//  Singleton.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

class Singleton {
    
    //Initializer access level change, now singleton class cannot be initialized again
    private init(){}
    
    static let sharedInstance = Singleton()
    
    let generalFunctions = GeneralFunctions()
    
    let alerts = Alerts()
    
    let appEnvironmentObject = AppEnvironmentObject()
    
    let apiServices = ApiServices()
    
    let jsonDecoder = JSONDecoder()
}
