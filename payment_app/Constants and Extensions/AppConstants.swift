//
//  AppConstants.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import SwiftUI

//MARK: - DeviceDimensions
struct DeviceDimensions {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

class AppURLs {
    static let baseURL = "https://6c9b-2401-4900-1c6e-8db9-648f-2338-a852-7acd.in.ngrok.io/"
    
    static func getAPIURL() -> String {
        return baseURL + "api/"
    }
    
    //    func updateAPIURL(_ urlString: String) {
    //        apiURL = urlString
    //    }
}

//MARK: - AppInfo
struct AppInfo {
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    static var appId = 0
}

//MARK: - UserDefaultKeys
struct UserDefaultKeys {
    static let apnDeviceToken = "apnDeviceToken"
    static let firebaseToken = "firebaseToken"
    static let isLoggedIn = "isLoggedIn"
    static let authToken = "authToken"
    static let userModel = "userModel"
    static let userModelUserID = "userModelUserID"
}

//MARK: - DateFormats
struct DateFormats {
    // yyyy - year
    // MM - month in numbers
    // MMM - month in 3 characters
    // MMMM - month name complete
    // dd - date
    // HH - 24 hours format
    // hh - 12 hours format
    // mm - minutes
    // ss - seconds
    // aa - AM/PM
    static let serverDF = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let ddMMMYYYYathhmmaa = "dd-MMM-yyyy at hh:mm aa"
    
    static let firebaseDF = "EEE MMM dd yyyy HH:mm:ss ZZZ"
    static let chatMessageDF = "dd MMM yyyy hh:mm aa"
}

//MARK: - enums
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum ParameterEncoding: String {
    case JSONBody, URLFormEncoded, FormData
}

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)
enum APIError: Error {
    case InternetNotConnected, UrlNotValid, MapError, InvalidHTTPURLResponse, InformationalError(Int), DecodingError, RedirectionalError(Int), ClientError(ClientErrorsEnum), ServerError(Int), Unknown(Int)
}

enum ClientErrorsEnum: Int {
    case BadRequest = 400, Unauthorized = 401, PaymentRequired = 402, Forbidden = 403, NotFound = 404, MethodNotAllowed = 405, NotAcceptable = 406, URITooLong = 414, Other
}

enum ApiStatus {
    case NotHitOnce, IsBeingHit, ApiHit, ApiHitWithError
}

enum LoginApiStatus {
    case NotHitOnce, IsBeingHit, OTPSent, FillDetails, FillBankDetails, LoggedIn, ApiHitWithError
}

enum FontEnum {
    case Light, Regular, Medium, SemiBold, Bold
}

enum NavigationEnum: Int {
    case Login, OTPVerify, FillDetails, FillBankDetails, HomeScreen, ProfileScreen, ScanQRScreen, PayToNumberScreen, PayToUPIIDScreen, QRCodeInfoScreen, WalletTransactionsScreen, BankAccountsScreen, PayToScreen, ProfileInfoScreen, ChatScreen, PaymentDetailsScreen
}

//MARK: - App Colors
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    static let blackColor = Color(.blackColor)
    static let blackColorForAllModes = Color(.blackColorForAllModes)
    
    static let darkGrayColor = Color(.darkGrayColor)
    static let defaultLightGray = Color(.defaultLightGray)
    static let greenColor = Color(.greenColor)
    static let lightBluishGrayColor = Color(.lightBluishGrayColor)
    static let lightGray = Color(.lightGray)
    static let lightPrimaryColor = Color(.lightPrimaryColor)
    static let placeHolderColor = Color(.placeHolderColor)
    static let primaryColor = Color(.primaryColor)
    static let redColor = Color(.redColor)
    
    static let whiteColor = Color(.whiteColor)
    static let whiteColorForAllModes = Color(.whiteColorForAllModes)
}

//MARK: - UIColor
extension UIColor {
    static let blackColor = UIColor(named: "blackColor") ?? UIColor.clear
    static let blackColorForAllModes = UIColor(named: "blackColorForAllModes") ?? UIColor.clear
    
    static let darkGrayColor = UIColor(named: "darkGrayColor") ?? UIColor.clear
    static let defaultLightGray = UIColor(named: "defaultLightGray") ?? UIColor.clear
    static let greenColor = UIColor(named: "greenColor") ?? UIColor.clear
    static let lightBluishGrayColor = UIColor(named: "lightBluishGrayColor") ?? UIColor.clear
    static let lightPrimaryColor = UIColor(named: "lightPrimaryColor") ?? UIColor.clear
    static let lightGray = UIColor(named: "lightGray") ?? UIColor.clear
    static let placeHolderColor = UIColor(named: "placeHolderColor") ?? UIColor.clear
    static let primaryColor = UIColor(named: "primaryColor") ?? UIColor.clear
    static let redColor = UIColor(named: "redColor") ?? UIColor.clear
    
    static let whiteColor = UIColor(named: "whiteColor") ?? UIColor.clear
    static let whiteColorForAllModes = UIColor(named: "whiteColorForAllModes") ?? UIColor.clear
}

//MARK: Font
extension Font {
    static func bitterLight(size: CGFloat) -> Font {
        return Font(UIFont.bitterLight(size: size) as CTFont)
    }
    
    static func bitterRegular(size: CGFloat) -> Font {
        return Font(UIFont.bitterRegular(size: size) as CTFont)
    }
    
    static func bitterMedium(size: CGFloat) -> Font {
        return Font(UIFont.bitterMedium(size: size) as CTFont)
    }
    
    static func bitterSemiBold(size: CGFloat) -> Font {
        return Font(UIFont.bitterSemiBold(size: size) as CTFont)
    }
    
    static func bitterBold(size: CGFloat) -> Font {
        return Font(UIFont.bitterBold(size: size) as CTFont)
    }
}

//MARK: - UIFont
extension UIFont {
    static func bitterLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bitterBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Bitter-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
