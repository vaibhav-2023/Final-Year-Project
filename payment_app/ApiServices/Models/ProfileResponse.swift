//
//  VerifyOTPResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import Foundation

//User Get Profile Model created on 11/01/23
//MARK: - LoginResponse
struct ProfileResponse: Codable {
    let status: Int?
    let success: Bool?
    let message: String?
    let data: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case status, success, message, data
    }
}
