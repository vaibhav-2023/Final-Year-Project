//
//  QrCodeScannedModel.swift
//  payment_app
//
//  Created by MacBook PRO on 16/01/23.
//

import Foundation

//This model will store value whenever QR Code will be scanned created on 16/01/23
//MARK: - QrCodeScannedModel
struct QrCodeScannedModel: Codable {
    let pa: String?
    let pn: String?
}
