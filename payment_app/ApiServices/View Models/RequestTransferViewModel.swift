//
//  RequestTransferViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/04/23.
//

import Combine

//Banks View Model created on 7/01/23
class RequestTransferViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var requestTransferAS: ApiStatus = .NotHitOnce
    
    private(set) var generatedQRCode: String? = nil
    
    //function to request transfer
    func getRequestTransfer(forAmount amount: String) {
        
        requestTransferAS = .IsBeingHit
        
        let userID = Singleton.sharedInstance.generalFunctions.getUserID()
        let params = ["amount": amount, "_id": userID]
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userGetQRWithAmount)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: RequestTransferResponse.self) { [weak self] in
            self?.getRequestTransfer(forAmount: amount)
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
                guard let self = self else { return }
                if let success = response.success, success {
                    self.generatedQRCode = response.qrCodeFile
                    self.requestTransferAS = .ApiHit
                } else {
                    self.generatedQRCode = nil
                    self.requestTransferAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
