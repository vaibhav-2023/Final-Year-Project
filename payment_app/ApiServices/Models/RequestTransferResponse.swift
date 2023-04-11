//
//  ContactModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import Foundation

//This Model will be used to send contacts to the server created on 07/01/23.
//MARK: - ContactsModel
struct ContactModel: Codable, Hashable {
    
    static func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    let name: String
    let number: String
    
    enum CodingKeys: String, CodingKey {
        case name, number
    }
}
