//
//  LoginViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import Foundation
import Combine
import UIKit

//view model used for login/register and verify OTP Api's created on 04/01/23
class LoginViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published private(set) var loginAS: LoginApiStatus = .NotHitOnce
    @Published private(set) var resendOTPAS: ApiStatus = .NotHitOnce
    @Published private(set) var fillDetailsAS: LoginApiStatus = .NotHitOnce
    
    private(set) var verifyOTPResponse: VerifyOTPResponse? = nil
    
    //variable to check is any api request is in progress
    var isAnyApiBeingHit: Bool {
        if loginAS == .IsBeingHit || resendOTPAS == .IsBeingHit || fillDetailsAS == .IsBeingHit {
            return true
        }
        return false
    }
    
    //save user information in device UserDefaults after login
    private func saveUserInformation(_ verifyOTPResponse: VerifyOTPResponse?) {
        self.verifyOTPResponse = verifyOTPResponse
        UserDefaults.standard.set(verifyOTPResponse?.token, forKey: UserDefaultKeys.authToken)
        Singleton.sharedInstance.generalFunctions.saveUserModel(verifyOTPResponse?.data)
    }
    
    //function to send OTP to mobile number
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
                //#if DEBUG
                if let otp = response.otp {
                    Singleton.sharedInstance.alerts.alertWith(title: "OTP", message: "\(otp)") { _ in
                        self?.loginAS = .OTPSent
                    }
                } else {
                    self?.loginAS = .OTPSent
                }
                //#else
//                self?.loginAS = .OTPSent
//                #endif
            } else {
                self?.loginAS = .ApiHitWithError
            }
        }.store(in: &cancellable)
    }
    
    //function to resend OTP to mobile number
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
                //#if DEBUG
                if let otp = response.otp {
                    Singleton.sharedInstance.alerts.alertWith(title: "OTP", message: "\(otp)")
                }
                //#endif
                self?.resendOTPAS = .ApiHit
            } else {
                self?.resendOTPAS = .ApiHitWithError
            }
        }.store(in: &cancellable)
    }
    
    //function to verify OTP
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
                //if user has verified OTP save user details and auth Token
                self?.saveUserInformation(response)
                //if user has filled personel details check if user has added bank accounts
                if let name = response.data?.name, !name.isEmpty, let vpa = response.data?.vpa, !vpa.isEmpty {
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
    
    //fill user details api added on 05/01/23
    func hitFillUserDetailsAPI(withVPANumber vpaNumber: String, name: String, email: String, andImageModel imageModel: ImageModel?) {
        
        fillDetailsAS = .IsBeingHit
        
        let params = ["_id": Singleton.sharedInstance.generalFunctions.getUserID(),
                      "name": name,
                      "vpa": vpaNumber,
                      "email": email] as JSONKeyPair
        
        var fileModel: [FileModel] = []
        //if user has selected any image, only then send image details
        if let imageData = imageModel?.imageData {
            fileModel.append(contentsOf: [FileModel(file: imageData,
                                                    fileKeyName: "user_profilePic",
                                                    fileName: "profilePic",
                                                    mimeType: imageModel?.mimeType ?? "image")])
        }
        
        var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .userUpdate)
        urlRequest?.addHeaders(shouldAddAuthToken: true)
        urlRequest?.addParameters(params, withFileModel: fileModel, as: .FormData)
        Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: ProfileResponse.self) { [weak self] in
            self?.hitFillUserDetailsAPI(withVPANumber: vpaNumber, name: name, email: email, andImageModel: imageModel)
        }.sink{ [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.fillDetailsAS = .ApiHitWithError
                break
            }
        } receiveValue: { [weak self] response in
            if let success = response.success, success {
                //save updated details of user in user details
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
