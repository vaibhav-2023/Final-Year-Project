//
//  AllBanksResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import Foundation

//This is the model which will be used when fetching data from all banks api created on 11/01/23
// MARK: - AllBanksResponse
struct AllBanksResponse: Codable {
    let success: Bool?
    let status, total: Int?
    let data: [BankModel?]?
}

//This is the model which will hold data of one single bank model
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
