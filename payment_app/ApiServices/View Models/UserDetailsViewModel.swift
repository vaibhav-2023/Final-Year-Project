//
//  UserDetailsViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 12/01/23.
//

import Combine

class UserDetailsViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var userDetailsAS: ApiStatus = .NotHitOnce
    
    private(set) var userDetails: UserModel? = nil
    
    var isAnyApiBeingHit: Bool {
        if userDetailsAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    func setUserDetails(_ userDetails: UserModel?) {
        self.userDetails = userDetails
    }
    
    func getDetailsOfUser() {
        
        userDetailsAS = .IsBeingHit
        
        let params = ["_id": userDetails?.id ?? ""] as JSONKeyPair
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userSingle)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
            self?.getDetailsOfUser()
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.userDetailsAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.userDetailsAS = .ApiHit
                } else {
                    self?.userDetailsAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
