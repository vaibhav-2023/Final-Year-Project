//
//  WalletTransactionsViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 13/01/23.
//

import Combine

//view model to fetch wallet transactions created on 13/01/23
class WalletTransactionsViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var getWalletTransactionsAS: ApiStatus = .NotHitOnce
    @Published private(set) var getWalletTransactionDetailsAS: ApiStatus = .NotHitOnce
    
    private var totalWalletTransactions = 0
    private var currentWalletTransactions = 0
    private(set) var walletTransactions: [WalletTransactionModel?] = []
    
    private(set) var singleWalletTransaction: WalletTransactionModel? = nil
    
    //variable to check is any api request is in progress
    var isAnyApiBeingHit: Bool {
        if getWalletTransactionsAS == .IsBeingHit || getWalletTransactionDetailsAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    //variable to check if all banks data is fetched or not
    var fetchedAllData: Bool {
        return totalWalletTransactions <= currentWalletTransactions
    }
    
    //paginate with index
    func paginateWithIndex(_ index: Int) {
        if getWalletTransactionsAS != .IsBeingHit && index == currentWalletTransactions - 1 && !fetchedAllData {
            getWalletTransactions(clearList: false)
        }
    }
    
    //api to fetch wallet transactions
    func getWalletTransactions(clearList: Bool = true) {
        
        getWalletTransactionsAS = .IsBeingHit
        
        if clearList {
            currentWalletTransactions = 0
            walletTransactions.removeAll()
        }
        
        let params = ["startpoint": currentWalletTransactions] as JSONKeyPair
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .walletAllClient)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: WalletTransactionsListResponse.self) { [weak self] in
            self?.getWalletTransactions(clearList: clearList)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.getWalletTransactionsAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.totalWalletTransactions = response.total ?? 0
                    self?.walletTransactions.append(contentsOf: response.data ?? [])
                    self?.currentWalletTransactions = self?.walletTransactions.count ?? 0
                    self?.getWalletTransactionsAS = .ApiHit
                } else {
                    self?.getWalletTransactionsAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func setWalletTransactionDetails(_ walletTransaction: WalletTransactionModel?) {
        if let walletTransaction {
            self.singleWalletTransaction = walletTransaction
        }
    }
    
    func getWalletTransacionDetails(withID id: String) {
        
        getWalletTransactionDetailsAS = .IsBeingHit
        
        let params = ["_id": id] as JSONKeyPair
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .walletSingle)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: SingleWalletTransactionResponse.self) { [weak self] in
            self?.getWalletTransacionDetails(withID: id)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.getWalletTransactionDetailsAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.singleWalletTransaction = response.data
                    self?.getWalletTransactionDetailsAS = .ApiHit
                } else {
                    self?.getWalletTransactionDetailsAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
