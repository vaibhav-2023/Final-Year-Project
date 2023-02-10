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
    @Published private(set) var logoutAS: ApiStatus = .NotHitOnce
    
    private(set) var userModel: UserModel? = Singleton.sharedInstance.generalFunctions.getUserModel()
    
    var isAnyApiBeingHit: Bool {
        if fillDetailsAS == .IsBeingHit || profileAPIAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    func hitFillUserDetailsAPI(withName name: String, email: String, andImageModel imageModel: ImageModel?) {
        
        fillDetailsAS = .IsBeingHit
        
        let params = ["_id": Singleton.sharedInstance.generalFunctions.getUserID(),
                      "name": name,
                      "email": email] as JSONKeyPair
        
        var fileModel: [FileModel] = []
        if let imageData = imageModel?.imageData {
            fileModel.append(contentsOf: [FileModel(file: imageData,
                                                    fileKeyName: "profilePic",
                                                    fileName: "profilePic",
                                                    mimeType: imageModel?.mimeType ?? "image")])
        }
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userUpdate)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, withFileModel: fileModel, as: .FormData)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
            self?.hitFillUserDetailsAPI(withName: name, email: email, andImageModel: imageModel)
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
                if let success = response.success, success {
                    Singleton.sharedInstance.generalFunctions.saveUserModel(response.data)
                    self?.fillDetailsAS = .ApiHit
                } else {
                    self?.fillDetailsAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func getProfile() {
        
        profileAPIAS = .IsBeingHit
        
        let params = ["_id": Singleton.sharedInstance.generalFunctions.getUserID()] as JSONKeyPair
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userSingle)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
            self?.getProfile()
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.profileAPIAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.userModel = response.data
                    Singleton.sharedInstance.generalFunctions.saveUserModel(self?.userModel)
                    self?.profileAPIAS = .ApiHit
                } else {
                    self?.profileAPIAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func logoutUser() {
        
        logoutAS = .IsBeingHit
        
        let params = ["_id": Singleton.sharedInstance.generalFunctions.getUserID()] as JSONKeyPair
        
        //user_profilePic
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .logout)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
            self?.logoutUser()
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.logoutAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    self?.logoutAS = .ApiHit
                    Singleton.sharedInstance.generalFunctions.deinitilseAllVariables()
                } else {
                    self?.logoutAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
