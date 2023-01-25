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
    
    case characters = "characters"
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
