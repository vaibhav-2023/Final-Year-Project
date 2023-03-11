//
//  FileModel.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//This is model which is used to send file to server,
//it store all the required info in a Model created on 31/12/22.
//MARK: - FileModel
struct FileModel: Codable {
    let file: Data
    let fileKeyName: String
    let fileName: String
    // mime type is file type(image, video etc.)
    let mimeType: String
}
