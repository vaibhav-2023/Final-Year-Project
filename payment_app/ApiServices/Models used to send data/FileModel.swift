//
//  FileModel.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//MARK: - FileModel
struct FileModel: Codable {
    let file: Data
    let fileKeyName: String
    let fileName: String
    // mime type is file type(image, video etc.)
    let mimeType: String
}
