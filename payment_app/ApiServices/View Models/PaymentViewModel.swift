//
//  PaymentViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 13/01/23.
//

import Combine

//view model to perform payment created on 13/01/23
class PaymentViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var addWalletTransactionAS: ApiStatus = .NotHitOnce
    
    //variable to check is any api request is in progress
    var isAnyApiBeingHit: Bool {
        if addWalletTransactionAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    //add new wallet transaction
    func addWalletTransactions(fromBankAccount: UserAddedBankAccountModel?,
                               toUser: UserModel?,
                               toBankAccount: UserAddedBankAccountModel?,
                               withAmount amount: String,
                               andNote note: String,
                               isSuccessfull: Bool) {
        
        addWalletTransactionAS = .IsBeingHit
        
        var params = ["paidByUserId": Singleton.sharedInstance.generalFunctions.getUserID(),
                      "fromBankId": fromBankAccount?.id ?? "",
                      "amount": amount,
                      "isPaymentSuccessful": true,
                      "remarks": note] as JSONKeyPair
        
        if let toUserId = toUser?.id {
            params["paidToUserId"] = toUserId
        } else if let json = Singleton.sharedInstance.generalFunctions.structToJSONString(toUser) {
            params["paidToUserData"] = json
        }
        
        if let toBankAccountID = toBankAccount?.id {
            params["toBankId"] = toBankAccountID
        }
        
        print(params)
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .walletAdd)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: SingleWalletTransactionResponse.self) { [weak self] in
            self?.addWalletTransactions(fromBankAccount: fromBankAccount,
                                        toUser: toUser,
                                        toBankAccount: toBankAccount,
                                        withAmount: amount,
                                        andNote: note,
                                        isSuccessfull: isSuccessfull)
        }
        .sink{ [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.addWalletTransactionAS = .ApiHitWithError
                break
            }
        } receiveValue: { [weak self] response in
            if let success = response.success, success {
                //when payment is added, send user to the payment details screen
                Singleton.sharedInstance.appEnvironmentObject.walletTransactionDetails = response.data
                Singleton.sharedInstance.appEnvironmentObject.changeContentView.toggle()
                self?.addWalletTransactionAS = .ApiHit
            } else {
                self?.addWalletTransactionAS = .ApiHitWithError
            }
        }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
