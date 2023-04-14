//
//  RequestTransferScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import SwiftUI

struct RequestTransferScreen: View {
    
    //For Handling View Model added
    @StateObject private var requestTransferVM = RequestTransferViewModel()
    
    //variables for screen
    @State private var amount = ""
    
    //constants for spacing and padding
    private var spacing: CGFloat = 10
    private var padding: CGFloat = 16
    
    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                HStack {
                    Text(Singleton.sharedInstance.generalFunctions.getCurrencySymbol())
                        .foregroundColor(.blackColor)
                        .fontCustom(.Medium, size: 16)
                    
                    MyTextField("0", text: $amount, fontEnum: .SemiBold, textSize: 40, maxLength: 6, keyboardType: .numberPad, fixedSize: true)
                }
                
                MaxWidthButton(text: AppTexts.request, fontEnum: .Medium) {
                    onPayClicked()
                }
                
                if let decodedData = requestTransferVM.generatedQRCode?.removeString(AppTexts.extraTextInFrontOfbase64String).base64StringToData,
                   let image = UIImage(data: decodedData) {
                    let width = DeviceDimensions.width * 0.6
                    Image(uiImage: image)
                        .resizable()
                        .foregroundColor(.blackColor)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: width)
                        .padding([.top, .horizontal], padding)
                    
                    Button {
                        Singleton.sharedInstance.generalFunctions.share(items: [image])
                    } label: {
                        Text(AppTexts.shareQRCode)
                            .fontCustom(.Medium, size: 17)
                            .foregroundColor(.primaryColor)
                            .padding(.vertical, padding/2)
                            .padding(.horizontal, padding)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.primaryColor, lineWidth: 1)
                            )
                    }
                }
                
            }.padding(padding)
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.request + " " + AppTexts.transfer)
    }
    
    //on pay button click
    private func onPayClicked() {
        let amountInInt = Int(amount) ?? 0
        let minimumAmountRequiredToRecharge = 1
        if amountInInt < minimumAmountRequiredToRecharge {
            Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.amountShouldBeAtleast + " " + Singleton.sharedInstance.generalFunctions.getCurrencyCode() + "\(minimumAmountRequiredToRecharge)")
        } else {
            requestTransferVM.getRequestTransfer(forAmount: amount)
        }
    }
}

struct RequestTransferScreen_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransferScreen()
    }
}
