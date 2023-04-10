//
//  AppConstants.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import SwiftUI

//Struct to get device width and height
//MARK: - DeviceDimensions
struct DeviceDimensions {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

//Class to storing app urls
class AppURLs {
    //static let baseURL = "https://upi.checksample.in/"
    static let baseURL = "http://192.168.1.118:6001/"
    
    static func getAPIURL() -> String {
        return baseURL + "api/"
    }
    
    //    func updateAPIURL(_ urlString: String) {
    //        apiURL = urlString
    //    }
    
    static func getImageURL() -> String {
        return baseURL
    }
}

//struct added on 10/04/23
//MARK: - AppKeys
struct AppKeys {
    static let stripeKey = "pk_test_51IXUkzSDJYiI36iU1g88Tmker1LPdaNDxqKClKcOi5fmiPsyYqwTZnmxI5GLdJC6m2TvBq2PwFCfgaEcEtFGeqcL000teouPjn"
}

//struct related to app info
//MARK: - AppInfo
struct AppInfo {
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    static var appId = 0
}

//static keys used for storing data in device storage
//MARK: - UserDefaultKeys
struct UserDefaultKeys {
    static let apnDeviceToken = "apnDeviceToken"
    static let firebaseToken = "firebaseToken"
    static let isLoggedIn = "isLoggedIn"
    static let authToken = "authToken"
    static let userModel = "userModel"
    static let userModelUserID = "userModelUserID"
}

//static Date Formats
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
    static let ddMMMYYYYathhmmaa = "dd-MMM-yyyy hh:mm aa"
    
    static let firebaseDF = "EEE MMM dd yyyy HH:mm:ss ZZZ"
    static let chatMessageDF = "dd MMM yyyy hh:mm aa"
}

//MARK: - enums
//enum for different API methods
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

//enum for sending data in an API
enum ParameterEncoding: String {
    case JSONBody, URLFormEncoded, FormData
}

//HTTP errors
//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)
enum APIError: Error {
    case InternetNotConnected, UrlNotValid, MapError, InvalidHTTPURLResponse, InformationalError(Int), DecodingError, RedirectionalError(Int), ClientError(ClientErrorsEnum), ServerError(Int), Unknown(Int)
}

//Errors ranging between 400–499
enum ClientErrorsEnum: Int {
    case BadRequest = 400, Unauthorized = 401, PaymentRequired = 402, Forbidden = 403, NotFound = 404, MethodNotAllowed = 405, NotAcceptable = 406, URITooLong = 414, Other
}

//For Handling Api Status
enum ApiStatus {
    case NotHitOnce, IsBeingHit, ApiHit, ApiHitWithError
}

//For Handling Login Api Status
enum LoginApiStatus {
    case NotHitOnce, IsBeingHit, OTPSent, FillDetails, FillBankDetails, LoggedIn, ApiHitWithError
}

//App Fonts Enum
enum FontEnum {
    case Light, Regular, Medium, SemiBold, Bold
}

//wallet transaction enum, created on on 10/04/23
enum WalletTransactionEnum: Int {
    case debit = 1, credit, walletRecharge
}

//App Navigation Enum
enum NavigationEnum: Int {
    case Login, OTPVerify, FillDetails, FillBankDetails, HomeScreen, ProfileScreen, ScanQRScreen, PayToVPAIDScreen, PayToContactScreen, PayToNumberScreen, QRCodeInfoScreen, WalletTransactionsScreen, BankAccountsScreen, PayToScreen, ProfileInfoScreen, ChatScreen, PaymentDetailsScreen, FillDetailsBankTransferScreen, RechargeWalletScreen, RequestTransferScreen, CheckWalletBalanceScreen
}

//MARK: - App Colors
//For having static App Colors and using them for SwiftUI Framework
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

//For having static App Colors and using them for UIKit Framework
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

//MARK: - Font
//For having static App Fonts and using them for SwiftUI Framework
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
//For having static App Fonts and using them for UIKit Framework
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
