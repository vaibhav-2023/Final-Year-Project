//
//  SingleWalletTransactionResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 13/01/23.
//

import Foundation

//This Model is used when single wallet transaction is fetched created on 13/01/23
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
