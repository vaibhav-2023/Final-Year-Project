//
//  RechargeWalletViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import Combine

//Recharge Wallet View Model created on 7/01/23
class RechargeWalletViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var requestTransferAS: ApiStatus = .NotHitOnce
    
    //variable to check is any api request is in progress, updated on 10/04/23
    var isAnyApiBeingHit: Bool {
        return requestTransferAS == .IsBeingHit
    }
    
    //function to request transfer
    func getRequestTransfer(forAmount amount: String, andStripeToken stripeToken: String) {
        
        requestTransferAS = .IsBeingHit
        
        let userID = Singleton.sharedInstance.generalFunctions.getUserID()
        let params = ["amount": amount, "sToken": stripeToken, "userId": userID]
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .walletRechargeWallet)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: BaseResponse.self) { [weak self] in
            self?.getRequestTransfer(forAmount: amount, andStripeToken: stripeToken)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.requestTransferAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.requestTransferAS = .ApiHit
                } else {
                    self?.requestTransferAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
