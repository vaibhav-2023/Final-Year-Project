//
//  AllBanksResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import Foundation

// MARK: - AllBanksResponse
struct AllBanksResponse: Codable {
    let success: Bool?
    let status, total: Int?
    let data: [BankModel]?
}

// MARK: - BankModel
struct BankModel: Codable, Hashable {
    
    static func == (lhs: BankModel, rhs: BankModel) -> Bool {
        return lhs.autoID == rhs.autoID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(autoID)
    }
    
    let autoID: Int?
    let name, profilePic: String?

    enum CodingKeys: String, CodingKey {
        case autoID = "autoId"
        case name, profilePic
    }
}
