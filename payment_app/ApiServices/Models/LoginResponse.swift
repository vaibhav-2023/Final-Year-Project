//
//  LoginResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation

//MARK: - LoginResponse
struct LoginResponse: Codable {
    let success: Bool?
    let data: UserModel?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case success, data
        case token
    }
}

//MARK: - UserModel
struct UserModel: Codable {
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
