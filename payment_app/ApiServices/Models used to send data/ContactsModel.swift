//
//  ContactsModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import Foundation

//This Model will be used to send contacts to the server created on 07/01/23.
//MARK: - ContactsModel
struct ContactsModel: Codable {
    let name: String
    let number: String
    
    enum CodingKeys: String, CodingKey {
        case name, number
    }
}
