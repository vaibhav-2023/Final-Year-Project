//
//  ProfileViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation
import Combine

class ProfileViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var fillDetailsAS: ApiStatus = .NotHitOnce
    @Published private(set) var profileAPIAS: ApiStatus = .NotHitOnce
    
    //private(set) var loginModel: LoginModel? = nil
    
    var isAnyApiBeingHit: Bool {
        if fillDetailsAS == .IsBeingHit || profileAPIAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    func hitFillUserDetailsAPI(withName name: String, andEmail email: String) {
        
        fillDetailsAS = .IsBeingHit
        
        let params = ["name": name,
                      "email": email] as [String : AnyObject]
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .login)
        urlRequest?.addHeaders()
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: LoginResponse.self) { [weak self] in
            self?.hitFillUserDetailsAPI(withName: name, andEmail: email)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.fillDetailsAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                self?.fillDetailsAS = .ApiHit
            }.store(in: &cancellable)
    }
    
    func getProfile() {
        
        profileAPIAS = .IsBeingHit
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .resendOTP)
        urlRequest?.addHeaders()
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: BaseResponse.self) { [weak self] in
            self?.getProfile()
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    self?.profileAPIAS = .ApiHit
                    break
                    case .failure(_):
                    self?.profileAPIAS = .ApiHitWithError
                    break
                }
            } receiveValue: { response in
                print("in \(#function)")
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
