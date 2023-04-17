//
//  StripeCardView.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import SwiftUI
import StripeCore
import Stripe
import StripePayments
import StripePaymentsUI

//View for displaying stripe fill card details view craeted on 07/04/23
struct StripeCardView: View {
    
    //variables used for card view
    @State private var stpPaymentMethodsParams = STPPaymentMethodParams()
    @State private var isLoading: Bool = false
    @State private var isComplete: Bool = false
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 10
    
    private let onComplete: (String) -> Void
    private let stripePaymentController = StripePaymentController()
    
    //Constructor
    init(onComplete: @escaping (String) -> Void) {
        //        let cardParams = STPPaymentMethodCardParams()
        //        cardParams.number = "4242424242424242"
        //        cardParams.cvc = "123"
        //        cardParams.expMonth = NSNumber(value: 12)
        //        cardParams.expYear = NSNumber(value: 24)
        //
        //        let billingDetails = STPPaymentMethodBillingDetails()
        //        billingDetails.name = "Luke"
        //        billingDetails.address?.postalCode = "144404"
        //        let paymentMethodParams =  STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            Text(AppTexts.fillCardDetails)
                .fontCustom(.Medium, size: 22)
            
            STPCardFormView.Representable.init(paymentMethodParams: $stpPaymentMethodsParams, isComplete: $isComplete)
                .frame(height: 160)
                .padding(.vertical, padding)
            
            MaxWidthButton(text: AppTexts.recharge, fontEnum: .Medium) {
                //payButtonTapped()
                createStripeToken()
            }
        }.padding(padding * 2)
            .background(Color.whiteColor)
            .cornerRadius(10)
            .showLoader(isPresenting: $isLoading)
    }
    
    private func payButtonTapped() {
        //        stpPaymentMethodsParams.card?.number
        //        stpPaymentMethodsParams.card?.expYear
        //        stpPaymentMethodsParams.card?.expMonth
        //        stpPaymentMethodsParams.card?.cvc
        //        stpPaymentMethodsParams.card?.name
        let paymentIntentParam = STPPaymentIntentParams(clientSecret: AppKeys.stripeKey)
        paymentIntentParam.paymentMethodParams = stpPaymentMethodsParams
        isLoading = true
        stripePaymentController.submitPayment(intent: paymentIntentParam) { (status, intent, error) in
            isLoading = false
            switch status {
            case .succeeded:
                onComplete(intent?.stripeId ?? "")
            case .canceled:
                Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.paymentIsCanceledTryAgain)
            case .failed:
                Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.paymentIsFailedTryAgain)
            }
        }
    }
    
    //function added on 10/04/23
    private func createStripeToken() {
        
        let params = STPCardParams()
        params.number = stpPaymentMethodsParams.card?.number ?? ""
        params.expYear = UInt(truncating: stpPaymentMethodsParams.card?.expYear ?? 0)
        params.expMonth = UInt(truncating: stpPaymentMethodsParams.card?.expMonth ?? 0)
        
        params.cvc = stpPaymentMethodsParams.card?.cvc
        params.name = Singleton.sharedInstance.generalFunctions.getUserModel()?.name ?? ""
            
            
        if STPCardValidator.validationState(forCard: params) == .valid {
            
            isLoading = true
            
            STPAPIClient.shared.createToken(withCard: params) { (token: STPToken?, error: Error?) in
                
                isLoading = false
                
                if let error {
                    Singleton.sharedInstance.alerts.errorAlertWith(message: error.localizedDescription)
                }
                
                guard let token else {
                    return
                }
                
                print("got token object", token)
                print("got token id", token.tokenId)
                onComplete(token.tokenId)
            }
        } else {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.invalidCardDetails)
        }
    }
}

struct StripeCardView_Previews: PreviewProvider {
    static var previews: some View {
        StripeCardView() { _ in
            
        }
    }
}
