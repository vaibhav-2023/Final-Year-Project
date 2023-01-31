//
//  CameraViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewModel: ViewModel {
    @Published var hasGrantedRequest: Bool = false
    
    func requestAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                self.hasGrantedRequest = true
            }
            print("in Camera .authorized")
        case .denied:
            handleDeniesRestrictedCase()
            print("in Camera .denied")
        case .restricted:
            handleDeniesRestrictedCase()
            print("in Camera .restricted")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.hasGrantedRequest = true
                    }
                    print("in Camera user Allowed Acess")
                } else {
                    DispatchQueue.main.async {
                        self.hasGrantedRequest = false
                    }
                    print("in Camera user Denied Acess")
                }
            })
            print("in Camera .notDetermined")
        @unknown default:
            print("in Camera @unknown default")
        }
    }
    
    private func handleDeniesRestrictedCase() {
        DispatchQueue.main.async {
            self.hasGrantedRequest = false
        }
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                self.showSettingsAlert()
        //            }
    }
    
    func showSettingsAlert() {
        let alert = Singleton.sharedInstance.alerts.getAlertController(ofStyle: .alert,
                                                   withTitle: AppTexts.AlertMessages.accessDenied,
                                                   andMessage: (AppInfo.appName ?? "This app") +
                                                                       " " + AppTexts.AlertMessages.requiresAccessToCameraToProceed +
                                                                       " " + AppTexts.AlertMessages.goToSettingsToGrantAccess)
        
        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.openSettings, style: .default) { action in
            Singleton.sharedInstance.generalFunctions.openAppSettings()
        })
        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.cancel, style: .cancel, handler: nil))
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func cancelAllCancellables() {
        
    }
}
