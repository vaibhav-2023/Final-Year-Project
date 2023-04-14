//
//  GeneralFunctions.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import UIKit
import CoreTelephony
import SwiftUI

typealias JSONKeyPair = [String: Any]

//Class Created on 31/12/22
class GeneralFunctions {
    
    //default country and it's numeric code
    private let defaultCountryCode = "in"
    private let defaultNumericCountryCode = "91"
    
    //get Top Window of the app
    func getTopWindow() -> UIWindow? {
        if #available(iOS 15, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
    //get top view controller of the app
    func getTopViewController() -> UIViewController? {
        let rootViewController = getTopWindow()?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        return rootViewController
    }
    
    //get height of the status bar
    func getStatusBarHeight() -> CGFloat {
        if let window = getTopWindow() {
            return window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return 0
    }
    
    //get height of the app bar/nav bar
    func getNavBarHeight() -> CGFloat {
        if let vc = getTopViewController() {
            return vc.navigationController?.navigationBar.bounds.height ?? 0
        }
        return 0
    }
    
    //for sharing items
    func share(items: [Any]) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let vc = getTopViewController() {
            vc.present(ac, animated: true, completion: nil)
        }
    }
    
    //convert model/struct to data
    func structToData<T: Encodable>(_ model: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            return jsonData
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    //convert model/struct to Json
    func structToJSON<T: Encodable>(_ model: T) -> Any? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return json
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    //convert model/struct to Json String
    func structToJSONString<T: Encodable>(_ model: T) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            return String(data: jsonData, encoding: .utf8)
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    func jsonString<T: Decodable>(_ jsonString: String, toStruct model: T.Type) -> T? {
        do {
            let data = Data(jsonString.utf8)
            return try JSONDecoder().decode(model.self, from: data)
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    //convert model/struct to Json to send in API
    func structToParameters<T: Encodable>(_ model: T) -> JSONKeyPair? {
        if let json = structToJSON(model) {
            if let parameter = json as? JSONKeyPair {
                return parameter
            }
        }
        return nil
    }
    
    //convert Json to model/Struct
    func jsonToStruct<T: Decodable>(json: JSONKeyPair, decodingStruct: T.Type) -> T? {
        do {
            let realData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let model = try Singleton.sharedInstance.jsonDecoder.decode(decodingStruct.self, from: realData)
            return model
        } catch {
            print("decoding error", error.localizedDescription)
        }
        return nil
    }
    
    //convert Json to String
    func jsonToString(json: AnyObject) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            return String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    //APN Token we receive is in form of Data convert it to String Format
    func convertApnTokenDataToString(_ deviceToken: Data) -> String {
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        print("Device-token", token)
        
        return token
    }
    
    //open app settings
    func openAppSettings() {
        if let settings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settings) {
            UIApplication.shared.open(settings)
        }
    }
    
    //get country code of Device
    func getCountryCodeOfDevice() -> String {
        ///to get country code with Locale
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//            return countryCode
//        }
        ///to get country code with SIM
//        if let carrier = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders?.values.first(where: { $0.isoCountryCode != nil }) {
//            if let countryCode = carrier.isoCountryCode {
//                return countryCode
//            }
//        }
        return defaultCountryCode
    }
    
    //get numeric country code of Device
    func getNumericCountryCodeOfDevice() -> String {
        //getCountryCodeOfDevice()
        return defaultNumericCountryCode
    }
    
    //get locale of device
    func getLocale() -> Locale {
        return Locale(identifier: "es_IN")
    }
    
    //get currency symbol
    func getCurrencySymbol() -> String {
        //Example: $, ₹
        //https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift
        return getLocale().currencySymbol ?? ""
    }
    
    //get currency code
    func getCurrencyCode() -> String {
        //Example: USD, INR
        //https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift
        if #available(iOS 16.0, *) {
            return getLocale().currency?.identifier ?? ""
        }
        return getLocale().currencyCode ?? ""
    }
    
    //save user details in device
    func saveUserModel(_ userModel: UserModel?) {
        if let userModel = userModel, let jsonUserModel = structToData(userModel) {
            UserDefaults.standard.set(jsonUserModel, forKey: UserDefaultKeys.userModel)
            UserDefaults.standard.set(userModel.id ?? "", forKey: UserDefaultKeys.userModelUserID)
        }
    }
    
    //check if user logged in or not
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn) == true
    }
    
    //get user id
    func getUserID() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.userModelUserID) ?? ""
    }
    
    //get user model
    func getUserModel() -> UserModel? {
        if let jsonData = UserDefaults.standard.data(forKey: UserDefaultKeys.userModel) {
            do{
                let data = try JSONDecoder().decode(UserModel.self, from: jsonData)
                return data
            }catch{
                print("error in \(#function)", error.localizedDescription)
            }
        }
        return nil
    }
    
    //clear all user defaults variables except APN Token and firebase token
    func deinitilseAllVariables() {
        var apnDeviceToken = ""
        if let myToken = UserDefaults.standard.value(forKey: UserDefaultKeys.apnDeviceToken) as? String  {
            apnDeviceToken = myToken
        }
        var firebaseToken = ""
        if let tokenValue = UserDefaults.standard.value(forKey: UserDefaultKeys.firebaseToken) as? String  {
            firebaseToken = tokenValue
        }
        
        //remove all user default values
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        //re-save APN Token and firebase token
        UserDefaults.standard.set(apnDeviceToken, forKey: UserDefaultKeys.apnDeviceToken)
        UserDefaults.standard.set(firebaseToken, forKey: UserDefaultKeys.firebaseToken)
        UserDefaults.standard.synchronize()
        
        Singleton.sharedInstance.appEnvironmentObject.changeContentView.toggle()
    }
}
