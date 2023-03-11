//
//  LoginResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation

//This is the model which will be used when fetching data from login api created on 04/01/23
//MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Int?
    let success: Bool?
    let message: String?
    let otp: Int?
    
    enum CodingKeys: String, CodingKey {
        case status, success, message, otp
    }
}
