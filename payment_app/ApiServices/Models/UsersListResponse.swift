//
//  UsersListResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 12/01/23.
//

import Foundation

// MARK: - AllBanksResponse
struct UsersListResponse: Codable {
    let success: Bool?
    let status, total: Int?
    let message: String?
    let data: [UserModel?]?
    
    enum CodingKeys: String, CodingKey {
        case success, status, total, message, data
    }
}
