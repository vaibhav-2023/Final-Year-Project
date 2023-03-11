//
//  GetAllBanksViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import Foundation
import Combine

//Banks View Model created on 11/01/23
class AllBanksViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var getBanksAS: ApiStatus = .NotHitOnce
    
    private var totalBanks = 0
    private var currentBanksLength = 0
    private(set) var banks: [BankModel?] = []
    
    //variable to check is any api request is in progress
    var isAnyApiBeingHit: Bool {
        if getBanksAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    //variable to check if all banks data is fetched or not
    var fetchedAllData: Bool {
        return totalBanks <= currentBanksLength
    }
    
    //paginate with index
    func paginateWithIndex(_ index: Int) {
        if getBanksAS != .IsBeingHit && index == currentBanksLength - 1 && !fetchedAllData {
            getAllBanks(clearList: false)
        }
    }
    
    //function to fetch bank details
    func getAllBanks(clearList: Bool = true) {
        
        getBanksAS = .IsBeingHit
        
        if clearList {
            currentBanksLength = 0
            banks.removeAll()
        }
        
        let params = ["startpoint": currentBanksLength]
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .bankAll)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: AllBanksResponse.self) { [weak self] in
            self?.getAllBanks(clearList: clearList)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.getBanksAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.totalBanks = response.total ?? 0
                    self?.banks.append(contentsOf: response.data ?? [])
                    self?.currentBanksLength = self?.banks.count ?? 0
                    self?.getBanksAS = .ApiHit
                } else {
                    self?.getBanksAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
