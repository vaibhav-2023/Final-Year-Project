//
//  WalletTransactionsListResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 13/01/23.
//

import Foundation

//This Model is used when getting list of wallet transactions created on 13/01/23
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

//This Model is used for storing single wallet transaction
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
    let paidByUserID, paidToUserID, paidToUserData: UserModel?
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
        case paidToUserData, amount, remarks, isPaymentSuccessful, isDelete, isBlocked, status, createdAt
        case fromBankID = "fromBankId"
        case toBankID = "toBankId"
    }
    
    //used to fetch user model to whom payment is done
    var getPaidToUserModel: UserModel? {
        if let paidToUserID {
            return paidToUserID
        }
        return paidToUserData
    }
}
