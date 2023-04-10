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

//This Model is used for storing single wallet transaction, updated on 10/04/23
// MARK: - WalletTransactionModel
struct WalletTransactionModel: Codable, Hashable {
    
    static func == (lhs: WalletTransactionModel, rhs: WalletTransactionModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String?
    let autoID, transactionType: Int?
    let paidByUserID, paidToUserID, paidToUserData, userID, toUserID: UserModel?
    let amount: Double?
    let remarks, fromComments, toComments: String?
    let isPaymentSuccessful, isDelete, isBlocked: Bool?
    let status: Bool?
    let createdAt, fromBankID, toBankID, paymentTransactionID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case autoID = "autoId"
        case transactionType
        case paidByUserID = "paidByUserId"
        case paidToUserID = "paidToUserId"
        case paidToUserData
        case userID = "userId"
        case toUserID = "toUserId"
        case amount, remarks, fromComments, toComments, isPaymentSuccessful, isDelete, isBlocked, status, createdAt
        case fromBankID = "fromBankId"
        case toBankID = "toBankId"
        case paymentTransactionID = "paymentTransactionId"
    }
    
    //used to fetch user model to who did the payment
    var getPaidByUserModel: UserModel? {
        if let userID {
            return userID
        }
        return paidByUserID
    }
    
    //used to fetch user model to whom payment is done
    var getPaidToUserModel: UserModel? {
        //userID added on 10/04/23
        if let toUserID {
            return toUserID
        } else if let paidToUserID {
            return paidToUserID
        }
        return paidToUserData
    }
}
