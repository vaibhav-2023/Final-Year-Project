//
//  Endpoints.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//MARK: - Endpoints
protocol EndpointsProtocol {
    func getURLString() -> String
}

//MARK: - AppEndpoints
enum AppEndpoints: String, EndpointsProtocol {
    func getURLString() -> String {
        return AppURLs.getAPIURL() + self.rawValue
    }
    
    case loginRegister = "loginRegister",
         resendOTP = "resendOTP",
         verifyOTP = "verifyOtp",
         userUpdate = "user/update",
         userSingle = "user/single",
         logout = "logout",
         sendContacts = "sendContacts",
         bankAll = "bank/all"
}

////MARK: - AppEndpointsWithParamters
//enum AppEndpointsWithParamters: EndpointsProtocol {
//    func getURLString() -> String {
//        switch self {
//        case .characters(let id):
//            return AppURLs.getAPIURL() + "characters" + "/\(id)"
//        }
//    }
//    
//    case characters(Int)
//}
