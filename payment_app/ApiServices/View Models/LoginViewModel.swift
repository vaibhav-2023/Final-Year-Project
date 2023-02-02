//
//  LoginViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation
import Combine
import UIKit

class LoginViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var loginAS: LoginApiStatus = .NotHitOnce
    @Published private(set) var resendOTPAS: ApiStatus = .NotHitOnce
    
    //private(set) var loginModel: LoginModel? = nil
    
    var isAnyApiBeingHit: Bool {
        if loginAS == .IsBeingHit || resendOTPAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    private func saveUserInformation(_ loginResponse: LoginResponse?) {
        UserDefaults.standard.set(loginResponse?.token, forKey: UserDefaultKeys.authToken)
        Singleton.sharedInstance.generalFunctions.saveUserModel(loginResponse?.data)
    }
    
    func sendOTPTo(mobileNumber: String, withCountryCode countryCode: String) {
        
        loginAS = .IsBeingHit
        
        let params = ["phone": mobileNumber,
                      "numericCountryCode": countryCode,
                      "countryCode": Singleton.sharedInstance.generalFunctions.getCountryCodeOfDevice()] as JSONKeyPair
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .loginRegister)
        urlRequest?.addHeaders()
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: LoginResponse.self) { [weak self] in
            self?.sendOTPTo(mobileNumber: mobileNumber, withCountryCode: countryCode)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.loginAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                self?.loginAS = .OTPSent
            }.store(in: &cancellable)
    }
    
    func resendOTPTo(mobileNumber: String, withCountryCode countryCode: String) {
        let params = ["mobile_number": mobileNumber] as JSONKeyPair
        
        resendOTPAS = .IsBeingHit
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .resendOTP)
        urlRequest?.addHeaders()
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: BaseResponse.self) { [weak self] in
            self?.resendOTPTo(mobileNumber: mobileNumber, withCountryCode: countryCode)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    self?.resendOTPAS = .ApiHit
                    break
                    case .failure(_):
                    self?.resendOTPAS = .ApiHitWithError
                    break
                }
            } receiveValue: { response in
                print("in \(#function)")
            }.store(in: &cancellable)
    }
    
    func verifyOTP(_ otp: String, sendToMobileNumber mobileNumber: String, withCountryCode countryCode: String) {
        
        let token = UserDefaults.standard.string(forKey: UserDefaultKeys.firebaseToken) ?? ""
        let version = UIDevice.current.systemVersion
        let deviceModel = UIDevice.getDeviceModel
        
        let params = ["mobile_number": mobileNumber,
                      "otp": otp,
                      "fcm_token": token,
                      "device_type": "iOS",
                      "is_ios": true,
                      "device_name": deviceModel,
                      "device_ios_version": version,
                      "device_model": deviceModel] as JSONKeyPair
        
        loginAS = .IsBeingHit
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .verifyOTP)
        urlRequest?.addHeaders()
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: LoginResponse.self) { [weak self] in
            self?.verifyOTP(otp, sendToMobileNumber: mobileNumber, withCountryCode: countryCode)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.loginAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    //if user details filled
                    self?.loginAS = .LoggedIn
                    //else
                    //self?.loginAS = .OTPSent
                    self?.saveUserInformation(response)
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
