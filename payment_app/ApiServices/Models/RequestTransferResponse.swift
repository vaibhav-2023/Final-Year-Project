//
//  RequestTransferResponse.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import Foundation

//This is a response created for storing data of requested transfer
// MARK: - RequestTransferResponse
struct RequestTransferResponse: Codable {
    let success: Bool?
    let status: Int?
    let message: String?
    let error: [String?]?
    let qrCodeFile: String?
}
