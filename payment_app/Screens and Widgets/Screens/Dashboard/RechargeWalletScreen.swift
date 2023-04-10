//
//  RechargeWalletScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import SwiftUI

struct RechargeWalletScreen: View {
    
    //environment variable to pop the screen
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //For Handling View Model added
    @StateObject private var rechargeWalletVM = RechargeWalletViewModel()
    
    //variables for screen
    @State private var amount = ""
    @State private var showStripeCardPopUp = false
    
    //constants for spacing and padding
    private var spacing: CGFloat = 10
    private var padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: spacing) {
                    HStack {
                        Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                            .foregroundColor(.blackColor)
                            .fontCustom(.Medium, size: 16)
                        MyTextField("0", text: $amount, fontEnum: .SemiBold, textSize: 40, maxLength: 6, keyboardType: .numberPad, fixedSize: true)
                            .padding(.vertical, padding)
                    }
                    
                    MaxWidthButton(text: AppTexts.pay, fontEnum: .Medium) {
                        onPayClicked()
                    }
                }.padding(padding)
            }
            
            if showStripeCardPopUp {
                stripeCardPopUp
                    //animation on 10/04/23
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            }
        }.animation(Animation.easeIn, value: showStripeCardPopUp)
            .setNavigationBarTitle(title: AppTexts.rechargeWallet)
            .showLoader(isPresenting: .constant(rechargeWalletVM.isAnyApiBeingHit))
            .onReceive(rechargeWalletVM.$requestTransferAS) { apiStatus in
                if apiStatus == .ApiHit {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
    }
    
    //view variable to show fill stripe card details view
    private var stripeCardPopUp: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    showStripeCardPopUp = true
                }
                .ignoresSafeArea()
            
            StripeCardView() { stripeToken in
                showStripeCardPopUp = false
                rechargeWalletVM.getRequestTransfer(forAmount: amount, andStripeToken: stripeToken)
            }.padding(padding)
        }
    }
    
    //on pay button click
    private func onPayClicked() {
        let amountInInt = Int(amount) ?? 0
        let minimumAmountRequiredToRecharge = 1
        if amountInInt < minimumAmountRequiredToRecharge {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.amountShouldBeAtleast + " " + Singleton.sharedInstance.generalFunctions.getCurrencyCode() + "\(minimumAmountRequiredToRecharge)")
        } else {
            showStripeCardPopUp = true
        }
    }
}

struct RechargeWalletScreen_Previews: PreviewProvider {
    static var previews: some View {
        RechargeWalletScreen()
    }
}
