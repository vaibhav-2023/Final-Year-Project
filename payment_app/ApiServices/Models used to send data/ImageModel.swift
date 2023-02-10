//
//  ImageModel.swift
//  payment_app
//
//  Created by MacBook PRO on 18/01/23.
//

import UIKit

//MARK: - ImageModel
struct ImageModel {
    var sourceType: UIImagePickerController.SourceType
    var uiImage: UIImage?
    var imageData: Data?
    var mimeType: String?
    
    init(sourceType: UIImagePickerController.SourceType,
         uiImage: UIImage? = nil,
         imageData: Data? = nil,
         mimeType: String? = nil) {
        self.sourceType = sourceType
        self.uiImage = uiImage
        self.imageData = imageData
        self.mimeType = mimeType
    }
}
