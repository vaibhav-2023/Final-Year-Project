//
//  SingleWalletTransactionResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 13/01/23.
//

import Foundation

//MARK: - SingleWalletTransactionResponse
struct SingleWalletTransactionResponse: Codable {
    let status: Int?
    let success: Bool?
    let message: String?
    let data: WalletTransactionModel?
    
    enum CodingKeys: String, CodingKey {
        case status, success, message, data
    }
}
