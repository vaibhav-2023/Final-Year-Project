//
//  Singleton.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//Singleton class for not having multiple instance of the same app
class Singleton {
    
    //Initializer access level change, now singleton class cannot be initialized again
    private init(){}
    
    static let sharedInstance = Singleton()
    
    //GeneralFunctions class instance
    let generalFunctions = GeneralFunctions()
    
    //Alerts class instance
    let alerts = Alerts()
    
    //AppEnvironmentObject class instance
    let appEnvironmentObject = AppEnvironmentObject()
    
    //ApiServices class instance
    let apiServices = ApiServices()
    
    //JSONDecoder class instance used for json to model encoding and decoding
    let jsonDecoder = JSONDecoder()
}
