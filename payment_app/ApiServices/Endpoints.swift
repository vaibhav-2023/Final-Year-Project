//
//  Endpoints.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//Protocol for Endpoints used in the app created on 31/12/22
//MARK: - Endpoints
protocol EndpointsProtocol {
    func getURLString() -> String
}

//MARK: - AppEndpoints created on 31/12/22
enum AppEndpoints: String, EndpointsProtocol {
    //generate URL String
    func getURLString() -> String {
        return AppURLs.getAPIURL() + self.rawValue
    }
    
    //Endpoints
    case loginRegister = "loginRegister",
         resendOTP = "resendOTP",
         verifyOTP = "verifyOtp",
         userUpdate = "user/update",
         userSingle = "user/single",
         userAll = "user/all",
         logout = "logout",
         sendContacts = "sendContacts",
         bankAll = "bank/all",
         bankAddAccount = "bank/addAccount",
         walletAdd = "wallet/add",
         walletAllClient = "wallet/allClient",
         walletSingle = "wallet/single",
         walletChatTransactions = "wallet/chatTransactions"
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
