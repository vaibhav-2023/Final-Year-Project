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

class GeneralFunctions {
    
    func getTopWindow() -> UIWindow? {
        if #available(iOS 15, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
    func getTopViewController() -> UIViewController? {
        let rootViewController = getTopWindow()?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        return nil
    }
    
    func getStatusBarHeight() -> CGFloat {
        if let window = getTopWindow() {
            return window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return 0
    }
    
    func getNavBarHeight() -> CGFloat {
        if let vc = getTopViewController() {
            return vc.navigationController?.navigationBar.bounds.height ?? 0
        }
        return 0
    }
    
    func structToData<T: Encodable>(_ model: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            return jsonData
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    func structToJSON<T: Encodable>(_ model: T) -> Any? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return json
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    func structToParameters<T: Encodable>(_ model: T) -> JSONKeyPair? {
        if let json = structToJSON(model){
            if let parameter = json as? JSONKeyPair {
                return parameter
            }
        }
        return nil
    }
    
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
    
    func jsonToString(json: AnyObject) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            return String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func convertApnTokenDataToString(_ deviceToken: Data) -> String {
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        print("Device-token", token)
        
        return token
    }
    
    func checkUpdateAvailable() {
//        if let urlString = getAppStoreUrlString() {
//            if let url = URL(string: urlString) {
//                let urlRequest = URLRequest(url: url)
//                if Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet {
//                    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//
//                        if let error = error {
//                            print("Request error: ", error)
//                            return
//                        }
//
//                        guard let data = data else { return }
//
//                        let jsonConvert = try? JSONSerialization.jsonObject(with: data, options: [])
//                        let json = jsonConvert as AnyObject
//
//                        if let results = json["results"] as? NSArray, let first = results.firstObject as? NSDictionary, let appStoreVersion = first["version"] as? String, let appVersion = AppConstants.AppInfo.appCurrentVersion {
////                            if let trackId = first["trackId"] as? Int {
////                                AppConstants.AppInfo.appId = trackId
////                            }
//                            DispatchQueue.main.async {
//                                // callback(appStoreVersion > appVersion)
//                                if appStoreVersion > appVersion {
//                                    Singleton.sharedInstance.alerts.updateAvailableAlert(version: appStoreVersion)
//                                }
//                            }
//                        }
//
//                    }.resume()
//                } else {
//                    let monitor = NWPathMonitor()
//                    let queue = DispatchQueue(label: "AppUpdateMonitor")
//                    monitor.pathUpdateHandler = { path in
//                        DispatchQueue.main.async {
//                            if path.status == .satisfied {
//                                self.checkUpdateAvailable()
//                                // self.checkUpdateAvailable(callback: callback)
//                                monitor.cancel()
//                            }
//                        }
//                    }
//                    monitor.start(queue: queue)
//                }
//            }
//        } else {
//            print("not able to get app store url")
//        }
    }
    
    func getLocale() -> Locale {
        return Locale(identifier: "es_IN")
    }
    
    func getCurrencySymbol() -> String {
        //Example: $, ₹
        //https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift
        return getLocale().currencySymbol ?? ""
    }
    
    func getCurrencyCode() -> String {
        //Example: USD, INR
        //https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift
        if #available(iOS 16.0, *) {
            return getLocale().currency?.identifier ?? ""
        }
        return getLocale().currencyCode ?? ""
    }
}
