//
//  LoginResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation

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
