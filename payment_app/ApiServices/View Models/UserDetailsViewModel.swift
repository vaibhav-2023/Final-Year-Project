//
//  UserDetailsViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 12/01/23.
//

import Combine

//view model to fetch details of single user created on 12/01/23
class UserDetailsViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var userDetailsAS: ApiStatus = .NotHitOnce
    
    private(set) var userDetails: UserModel? = nil
    
    //variable to check is any api request is in progress
    var isAnyApiBeingHit: Bool {
        if userDetailsAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    //function to update user details stored in the view model
    func setUserDetails(_ userDetails: UserModel?) {
        self.userDetails = userDetails
    }
    
    //function to get details of the user
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
    
    //function to get details of user with qr code scanner
    func getUser(withQRCodeScannedModel qrCodeScannedModel: QrCodeScannedModel) {
        
        userDetailsAS = .IsBeingHit
        
        //let mobileNumber = String(qrCodeScannedModel.pa?.prefix(10) ?? "")
        let vpa = String(qrCodeScannedModel.pa?.prefix(10) ?? "")
        let params = ["startpoint": 0, "search": vpa] as JSONKeyPair
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userAll)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: UsersListResponse.self) { [weak self] in
            self?.getUser(withQRCodeScannedModel: qrCodeScannedModel)
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
                    if let userDetails = (response.data ?? []).first {
                        self?.userDetails = userDetails
                    } else {
                        //                        self?.userDetails = UserModel(id: nil, userAutoID: nil, name: qrCodeScannedModel.pn ?? "", email: nil, phone: mobileNumber, otp: nil, profilePic: nil, countryCode: Singleton.sharedInstance.generalFunctions.getCountryCodeOfDevice(), numericCountryCode: Singleton.sharedInstance.generalFunctions.getNumericCountryCodeOfDevice(), userType: nil, isDelete: nil, isBlocked: nil, firebaseToken: nil, status: nil, banks: nil, createdAt: nil, vpa: nil, qrCodeFile: nil, walletAmount: nil, walletBalance: nil)
                    }
                    self?.userDetailsAS = .ApiHit
                } else {
                    self?.userDetailsAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    //function to get details of user with contact model added on 08/04/2023
    func getUser(withContactModel contactModel: ContactModel?) {
        
        userDetailsAS = .IsBeingHit
        
        //let mobileNumber = String(qrCodeScannedModel.pa?.prefix(10) ?? "")
        let number = (contactModel?.number ?? "").removeString("+")
        let params = ["startpoint": 0, "search": number] as JSONKeyPair
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userAll)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: UsersListResponse.self) { [weak self] in
            self?.getUser(withContactModel: contactModel)
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
                    if let userDetails = (response.data ?? []).first {
                        self?.userDetails = userDetails
                    } else {
                        Singleton.sharedInstance.alerts.errorAlertWith(message: AppTexts.AlertMessages.itSeemsLikeThisUserIsNotRegisteredWithOurApp)
                    }
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
