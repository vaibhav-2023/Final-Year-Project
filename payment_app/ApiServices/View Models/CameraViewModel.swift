//
//  CameraViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import Foundation
import AVFoundation
import UIKit

//View Model to handle camera permissions created on 07/01/23
class CameraViewModel: ViewModel {
    @Published var hasGrantedRequest: Bool = false
    
    //request for camera permission
    func requestAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            handleAllowedCase()
            print("in Camera .authorized")
        case .denied:
            handleDeniedRestrictedCase()
            print("in Camera .denied")
        case .restricted:
            handleDeniedRestrictedCase()
            print("in Camera .restricted")
        case .notDetermined:
            //if permission is not determined then request for permission
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (granted: Bool) in
                if granted {
                    self?.handleAllowedCase()
                    print("in Camera user Allowed Access")
                } else {
                    DispatchQueue.main.async {
                        self?.hasGrantedRequest = false
                    }
                    print("in Camera user Denied Access")
                }
            })
            print("in Camera .notDetermined")
        @unknown default:
            print("in Camera @unknown default")
        }
    }
    
    private func handleAllowedCase() {
        DispatchQueue.main.async {
            self.hasGrantedRequest = true
        }
    }
    
    private func handleDeniedRestrictedCase() {
        DispatchQueue.main.async {
            self.hasGrantedRequest = false
        }
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                self.showSettingsAlert()
        //            }
    }
    
    //if user has not given camera, we show the open app settings option with this method
    func showSettingsAlert() {
        let alert = Singleton.sharedInstance.alerts.getAlertController(ofStyle: .alert,
                                                   withTitle: AppTexts.AlertMessages.accessDenied,
                                                                       andMessage: (AppInfo.appName ?? AppTexts.thisApp) +
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
