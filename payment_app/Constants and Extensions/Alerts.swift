//
//  Alerts.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import UIKit

//Singleton Class for creating and presting alerts created on 31/12/22
class Alerts {
    //MARK: - variables
    private let attributedTitleKey = "attributedTitle"
    private let attributedMessageKey = "attributedMessage"
    
    private let titleAttributes = [NSAttributedString.Key.font: UIFont.bitterMedium(size: 17), NSAttributedString.Key.foregroundColor: UIColor.blackColor]
    private let messageAttributes = [NSAttributedString.Key.font: UIFont.bitterRegular(size: 14), NSAttributedString.Key.foregroundColor: UIColor.blackColor]
    
    //function to show alert as a toast
    func showToast(withMessage message: String, seconds: Double = 2.0) {
        let alert = getAlertController(ofStyle: .alert, withTitle: message, andMessage: nil)
        //alert.view.backgroundColor = UIColor.lightPrimaryColor
        //alert.view.alpha = 0.6
        //alert.view.layer.cornerRadius = 15
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    //function get Alert Controller with only title and message
    func getAlertController(ofStyle style: UIAlertController.Style, withTitle title: String?, andMessage message: String?) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "", preferredStyle: style)
        
        if let title {
            let titleString = NSAttributedString(string: title, attributes: titleAttributes)
            alert.setValue(titleString, forKey: attributedTitleKey)
        }
        
        if let message {
            let messageString = NSAttributedString(string: message, attributes: messageAttributes)
            alert.setValue(messageString, forKey: attributedMessageKey)
        }
        
        return alert
    }
    
    //create an error alert with error title and message
    func errorAlertWith(message: String){
        alertWith(title: AppTexts.AlertMessages.errorWithExclamation, message: message)
    }

    //alert with default button and action on it
    func alertWith(title: String, message: String?,
                   defaultButtonTitle: String = AppTexts.AlertMessages.ok,
                   defaultButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .alert, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: defaultButtonTitle, style: UIAlertAction.Style.default, handler: defaultButtonAction))

        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    //alert with default and action button and action on both of them
    func alertWith(title: String, message: String?,
                   defaultButtonTitle: String = AppTexts.AlertMessages.ok,
                   defaultButtonAction: ((UIAlertAction) -> Void)? = nil,
                   cancelButtonTitle: String = AppTexts.AlertMessages.cancel,
                   cancelButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .alert, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: defaultButtonTitle, style: UIAlertAction.Style.default, handler: defaultButtonAction))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: cancelButtonAction))

        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    //action sheet with 3 buttons and action on all of them
    func actionSheetWith(title: String, message: String?,
                         firstDefaultButtonTitle: String,
                         firstDefaultButtonAction: @escaping ((UIAlertAction) -> Void),
                         secondDefaultButtonTitle: String,
                         secondDefaultButtonAction: @escaping ((UIAlertAction) -> Void),
                         cancelButtonTitle: String = AppTexts.AlertMessages.cancel,
                         cancelButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .actionSheet, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: firstDefaultButtonTitle, style: UIAlertAction.Style.default, handler: firstDefaultButtonAction))
        alert.addAction(UIAlertAction(title: secondDefaultButtonTitle, style: UIAlertAction.Style.default, handler: secondDefaultButtonAction))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: cancelButtonAction))

        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }

    //alert for no internet found
    func internetNotConnectedAlert(outputBlock : @escaping () -> Void){
        let alert = getAlertController(ofStyle: .alert,
                                       withTitle: AppTexts.AlertMessages.networkUnreachableWithExclamation,
                                       andMessage: AppTexts.AlertMessages.youAreNotConnectedToInternet)

        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.tapToRetry, style: UIAlertAction.Style.default) { _ in
            outputBlock()
        })

        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }

    //alert for handling 401 status code added on 09/01/23
    func handle401StatueCode(){
        let alert = getAlertController(ofStyle: .alert,
                                       withTitle: AppTexts.AlertMessages.sessionExpiredWithExclamation,
                                       andMessage: AppTexts.AlertMessages.yourSessionHasExpiredPleaseLoginAgain)

        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.ok.uppercased(), style: UIAlertAction.Style.default, handler: { _ in
            Singleton.sharedInstance.generalFunctions.deinitilseAllVariables()
        }))


        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
}
