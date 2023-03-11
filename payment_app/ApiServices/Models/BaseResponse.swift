//
//  BaseResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation

//This is a common response created on 04/01/23
// MARK: - BaseResponse
struct BaseResponse: Codable {
    let success: Bool?
    let status: Int?
    let message: String?
    let error: [String?]?
}
