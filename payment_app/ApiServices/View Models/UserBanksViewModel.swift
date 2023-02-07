//
//  UserBanksViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import Foundation
import Combine

class UserBanksViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var addBankAS: ApiStatus = .NotHitOnce
    
    var isAnyApiBeingHit: Bool {
        if addBankAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    func addBankAccount(ofBank bankID: BankModel?, withAccountNumber accountNumber: String, andIFSC ifsc: String) {
        
        addBankAS = .IsBeingHit
        
        let params = ["bankId": bankID?.autoID ?? 0,
                      "accountNumber": accountNumber,
                      "userId": Singleton.sharedInstance.generalFunctions.getUserID()] as JSONKeyPair
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .bankAddAccount)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
            self?.addBankAccount(ofBank: bankID, withAccountNumber: accountNumber, andIFSC: ifsc)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.addBankAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    Singleton.sharedInstance.generalFunctions.saveUserModel(response.data)
                    self?.addBankAS = .ApiHit
                } else {
                    self?.addBankAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
