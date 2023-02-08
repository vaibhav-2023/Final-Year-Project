//
//  UsersViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 12/01/23.
//

import Foundation
import Combine

class UsersViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var getSearchedUsersAS: ApiStatus = .NotHitOnce
    
    private var totalSearchResultUsers = 0
    private var currentSearchResultUsers = 0
    private(set) var searchResultUsers: [UserModel?] = []
    
    var isAnyApiBeingHit: Bool {
        if getSearchedUsersAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    var fetchedAllData: Bool {
        return totalSearchResultUsers <= currentSearchResultUsers
    }
    
    func paginateWithIndex(_ index: Int, andSearchText searchText: String) {
        if getSearchedUsersAS != .IsBeingHit && index == currentSearchResultUsers - 1 && !fetchedAllData {
            searchUsers(withMobileNumber: searchText, clearList: false)
        }
    }
    
    func searchUsers(withMobileNumber mobileNumber: String, clearList: Bool = true) {
        
        getSearchedUsersAS = .IsBeingHit
        
        if clearList {
            currentSearchResultUsers = 0
            searchResultUsers.removeAll()
        }
        
        let params = ["startpoint": currentSearchResultUsers, "search": mobileNumber] as JSONKeyPair
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userAll)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: UsersListResponse.self) { [weak self] in
            self?.searchUsers(withMobileNumber: mobileNumber, clearList: clearList)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.getSearchedUsersAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.totalSearchResultUsers = response.total ?? 0
                    self?.searchResultUsers.append(contentsOf: response.data ?? [])
                    self?.currentSearchResultUsers = self?.searchResultUsers.count ?? 0
                    self?.getSearchedUsersAS = .ApiHit
                } else {
                    self?.getSearchedUsersAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
