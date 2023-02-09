//
//  ChatViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 17/01/23.
//

import Combine

class ChatViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var getChatWalletTransactionsAS: ApiStatus = .NotHitOnce
    
    private var totalChatWalletTransactions = 0
    private var currentChatWalletTransactions = 0
    private(set) var chatWalletTransactions: [WalletTransactionModel?] = []
    
    private(set) var singleWalletTransaction: WalletTransactionModel? = nil
    
    var isAnyApiBeingHit: Bool {
        if getChatWalletTransactionsAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    var fetchedAllData: Bool {
        return totalChatWalletTransactions <= currentChatWalletTransactions
    }
    
    func paginateWithIndex(_ index: Int, andSecondUserID secondUserID: String) {
        if getChatWalletTransactionsAS != .IsBeingHit && index == currentChatWalletTransactions - 1 && !fetchedAllData {
            getChatWalletTransactionsWith(secondUserID: secondUserID, clearList: false)
        }
    }
    
    func getChatWalletTransactionsWith(secondUserID: String, clearList: Bool = true) {
        
        getChatWalletTransactionsAS = .IsBeingHit
        
        if clearList {
            currentChatWalletTransactions = 0
            chatWalletTransactions.removeAll()
        }
        
        let params = [//"startpoint": currentChatWalletTransactions,
                      "profileUserId": Singleton.sharedInstance.generalFunctions.getUserID(),
                      "secondUserId": secondUserID] as JSONKeyPair
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .walletChatTransactions)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: WalletTransactionsListResponse.self) { [weak self] in
            self?.getChatWalletTransactionsWith(secondUserID: secondUserID, clearList: clearList)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.getChatWalletTransactionsAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.totalChatWalletTransactions = response.total ?? 0
                    self?.chatWalletTransactions.append(contentsOf: response.data ?? [])
                    self?.currentChatWalletTransactions = self?.chatWalletTransactions.count ?? 0
                    self?.getChatWalletTransactionsAS = .ApiHit
                } else {
                    self?.getChatWalletTransactionsAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
