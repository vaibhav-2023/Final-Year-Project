//
//  ContactsModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import Foundation

//MARK: - ContactsModel
struct ContactsModel: Codable {
    let name: String
    let number: String
    
    enum CodingKeys: String, CodingKey {
        case name, number
    }
}
