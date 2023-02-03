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
    @Published private(set) var fillDetailsAS: LoginApiStatus = .NotHitOnce
    
    //private(set) var loginModel: LoginModel? = nil
    
    var isAnyApiBeingHit: Bool {
        if loginAS == .IsBeingHit || resendOTPAS == .IsBeingHit || fillDetailsAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    private func saveUserInformation(_ verifyOTPResponse: VerifyOTPResponse?) {
        UserDefaults.standard.set(verifyOTPResponse?.token, forKey: UserDefaultKeys.authToken)
        Singleton.sharedInstance.generalFunctions.saveUserModel(verifyOTPResponse?.data)
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
                if let success = response.success, success {
                    #if DEBUG
                        Singleton.sharedInstance.alerts.alertWith(title: "OTP", message: "\(response.otp ?? 0)") { _ in
                            self?.loginAS = .OTPSent
                        }
                    #else
                        self?.loginAS = .OTPSent
                    #endif
                } else {
                    self?.loginAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func resendOTPTo(mobileNumber: String, withCountryCode countryCode: String) {
        let params = ["phone": mobileNumber,
                      "numericCountryCode": countryCode,
                      "countryCode": Singleton.sharedInstance.generalFunctions.getCountryCodeOfDevice()] as JSONKeyPair
        
        resendOTPAS = .IsBeingHit
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .loginRegister)
        urlRequest?.addHeaders()
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: LoginResponse.self) { [weak self] in
            self?.resendOTPTo(mobileNumber: mobileNumber, withCountryCode: countryCode)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    break
                    case .failure(_):
                    self?.resendOTPAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                if let success = response.success, success {
                    #if DEBUG
                        Singleton.sharedInstance.alerts.alertWith(title: "OTP", message: "\(response.otp ?? 0)")
                    #endif
                    self?.resendOTPAS = .ApiHit
                } else {
                    self?.resendOTPAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func verifyOTP(_ otp: String, sendToMobileNumber mobileNumber: String, withCountryCode countryCode: String) {
        
        let token = UserDefaults.standard.string(forKey: UserDefaultKeys.firebaseToken) ?? ""
        let version = UIDevice.current.systemVersion
        let deviceModel = UIDevice.getDeviceModel
        
        let params = ["phone": mobileNumber,
                      "otp": otp,
                      "firebaseToken": token,
                      "device_type": "iOS",
                      "is_ios": true,
                      "device_name": deviceModel,
                      "device_ios_version": version,
                      "device_model": deviceModel] as JSONKeyPair
        
        loginAS = .IsBeingHit
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .verifyOTP)
        urlRequest?.addHeaders()
        urlRequest?.addParameters(params, as: .URLFormEncoded)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: VerifyOTPResponse.self) { [weak self] in
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
                    self?.saveUserInformation(response)
                    if let name = response.data?.name, !name.isEmpty {
                        if let banks = response.data?.banks, !banks.isEmpty {
                            self?.loginAS = .LoggedIn
                        } else {
                            self?.loginAS = .FillBankDetails
                        }
                    } else {
                        self?.loginAS = .FillDetails
                    }
                } else {
                    self?.loginAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func hitFillUserDetailsAPI(withName name: String, andEmail email: String) {
        
        fillDetailsAS = .IsBeingHit
        
        let params = ["_id": Singleton.sharedInstance.generalFunctions.getUserID(),
                      "name": name,
                      "email": email] as JSONKeyPair
        
        //let fileModel = FileModel(file: <#T##Data#>, fileKeyName: <#T##String#>, fileName: <#T##String#>, mimeType: <#T##String#>)
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userUpdate)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, as: .FormData)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
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
                if let success = response.success, success {
                    Singleton.sharedInstance.generalFunctions.saveUserModel(response.data)
                    if let banks = response.data?.banks, !banks.isEmpty {
                        self?.loginAS = .LoggedIn
                    } else {
                        self?.loginAS = .FillBankDetails
                    }
                } else {
                    self?.loginAS = .ApiHitWithError
                }
            }.store(in: &cancellable)
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}
