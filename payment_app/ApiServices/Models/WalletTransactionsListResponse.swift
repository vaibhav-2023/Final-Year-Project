//
//  WalletTransactionsListResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 13/01/23.
//

import Foundation

// MARK: - WalletTransactionsListResponse
struct WalletTransactionsListResponse: Codable {
    let success: Bool?
    let status, total: Int?
    let message: String?
    let data: [WalletTransactionModel?]?
    
    enum CodingKeys: String, CodingKey {
        case success, status, total, message, data
    }
}

// MARK: - WalletTransactionModel
struct WalletTransactionModel: Codable, Hashable {
    
    static func == (lhs: WalletTransactionModel, rhs: WalletTransactionModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String?
    let autoID: Int?
    let paidByUserID, paidToUserID: UserModel?
    let amount: Double?
    let remarks: String?
    let isPaymentSuccessful, isDelete, isBlocked: Bool?
    let status: Bool?
    let createdAt, fromBankID, toBankID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case autoID = "autoId"
        case paidByUserID = "paidByUserId"
        case paidToUserID = "paidToUserId"
        case amount, remarks, isPaymentSuccessful, isDelete, isBlocked, status, createdAt
        case fromBankID = "fromBankId"
        case toBankID = "toBankId"
    }
}
