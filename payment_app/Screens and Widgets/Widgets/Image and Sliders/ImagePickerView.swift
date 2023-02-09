//
//  ImagePickerView.swift
//  payment_app
//
//  Created by MacBook PRO on 17/01/23.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var uiImage: UIImage
    @Binding var imageData: Data
    @Binding var sourceType: UIImagePickerController.SourceType
    
    init(uiImage: Binding<UIImage>? = nil,
         imageData: Binding<Data>,
         sourceType: Binding<UIImagePickerController.SourceType>) {
        
        if let uiImage = uiImage {
            self._uiImage = uiImage
        }else{
            self._uiImage = .constant(UIImage())
        }
        
        self._imageData = imageData
        self._sourceType = sourceType
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController(navigationBarStyle: .black)
        imagePicker.navigationBar.tintColor = .black
        imagePicker.sourceType = self.sourceType
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
                self.parent.imageData = getImageData
                self.parent.uiImage = image
            }
            picker.dismiss(animated: true)
        }
        
        @objc func data() {
            print("hahahaha")
        }
    }
}

extension UIImagePickerController {
    convenience init(navigationBarStyle: UIBarStyle) {
        self.init()
        self.navigationBar.barStyle = navigationBarStyle
    }
}
