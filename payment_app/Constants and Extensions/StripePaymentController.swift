//
//  StripePaymentController.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import UIKit
import StripePayments

//https://medium.com/geekculture/subscription-payment-using-stripe-ios-swiftui-sdk-409a9fdc1a0
class StripePaymentController: UIViewController {
    func submitPayment(intent: STPPaymentIntentParams,
                       completion: @escaping (STPPaymentHandlerActionStatus, STPPaymentIntent?, NSError?) -> Void) {
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(intent, with: self) { (status,intent,error) in
            completion(status,intent,error)
        }
    }
}

//MARK: - STPAuthenticationContext
extension StripePaymentController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
