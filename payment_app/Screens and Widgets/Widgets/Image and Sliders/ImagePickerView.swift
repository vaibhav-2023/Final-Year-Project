//
//  ImagePickerView.swift
//  payment_app
//
//  Created by MacBook PRO on 17/01/23.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding private var imageModel: ImageModel
    
    init(imageModel: Binding<ImageModel>) {
        self._imageModel = imageModel
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController(navigationBarStyle: .black)
        imagePicker.navigationBar.tintColor = .black
        imagePicker.sourceType = imageModel.sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //uiViewController.navigationBar.barTintColor = .primaryColor
        //uiViewController.navigationBar.tintColor = .primaryColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let resizedImage = image.resizedTo1MB() {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let getImageData = image.jpegData(compressionQuality: 1.0) ?? Data()
                self.parent.imageModel.imageData = getImageData
                self.parent.imageModel.uiImage = image
                if picker.sourceType == .savedPhotosAlbum, let assetPath = info[.imageURL] as? URL {
                    self.parent.imageModel.mimeType = assetPath.getMimeType()
                } else {
                    //when image is picked from camera
                    self.parent.imageModel.mimeType = getImageData.format
                }
            }
            picker.dismiss(animated: true)
        }
    }
}

extension UIImagePickerController {
    convenience init(navigationBarStyle: UIBarStyle) {
        self.init()
        self.navigationBar.barStyle = navigationBarStyle
    }
}
