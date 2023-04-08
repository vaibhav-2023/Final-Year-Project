//
//  VerifyOTPResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import Foundation

//Model used for api to verify OTP created on 11/01/23
//MARK: - VerifyOTPResponse
struct VerifyOTPResponse: Codable {
    let status: Int?
    let success: Bool?
    let message: String?
    let data: UserModel?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case status, success, message
        case data, token
    }
}

//This is the model of the user details
// MARK: - UserModel
struct UserModel: Codable, Hashable {
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String?
    let userAutoID: Int?
    let name, email, phone: String?
    let otp: Int?
    let profilePic, countryCode, numericCountryCode: String?
    let userType: Int?
    let isDelete, isBlocked: Bool?
    let firebaseToken: String?
    let status: Bool?
    let banks: [UserAddedBankAccountModel?]?
    let createdAt: String?
    let vpa, qrCodeFile: String?
    let walletAmount: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userAutoID = "userAutoId"
        case name, email, phone, otp, profilePic, countryCode, numericCountryCode, userType, isDelete, isBlocked
        case firebaseToken, status, banks, createdAt, vpa, qrCodeFile, walletAmount
    }
}

//This is the model which will hold the User Added Bank Accounts
// MARK: - UserAddedBankAccountModel
struct UserAddedBankAccountModel: Codable, Hashable {
    
    static func == (lhs: UserAddedBankAccountModel, rhs: UserAddedBankAccountModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id, accountNumber: String?
    let bankID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accountNumber
        case bankID = "bankId"
    }
}
