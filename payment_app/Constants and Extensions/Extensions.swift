//
//  Extensions.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import SwiftUI
import Combine
import MobileCoreServices
import UniformTypeIdentifiers

//MARK: - UIApplication
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addTapGestureRecognizer() {
        guard let window = Singleton.sharedInstance.generalFunctions.getTopWindow() else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

//MARK: - UIGestureRecognizerDelegate
extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

//MARK: - UIDevice
extension UIDevice {
    static var getDeviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return modelCode ?? ""
    }
}

//MARK: - URL
extension URL {
    func getMimeType() -> String {
        if #available(iOS 15, *) {
            if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
                return mimeType
            }
        } else {
            //https://stackoverflow.com/questions/31243371/path-extension-and-mime-type-of-file-in-swift
            if let retainedValue = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, self.pathExtension as NSString, nil)?.takeRetainedValue(),
               let mimetype = UTTypeCopyPreferredTagWithClass(retainedValue, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        
        return "application/octet-stream"
    }
}

//MARK: - View
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
    
    func showLoader(isPresenting: Binding<Bool>) -> some View {
        ZStack {
            self.disabled(isPresenting.wrappedValue)
            Loader(isPresenting: isPresenting)
        }
    }
    
    func setNavigationBarTitle(title: String, textSize: CGFloat = 18) -> some View {
        self.navigationBarTitle(title, displayMode: .inline)
            //.navigationBarItems(leading: AppBarText(title: title, textSize: textSize))
    }
}

//MARK: - Text
extension Text {
    func fontCustom(_ font: FontEnum, size: CGFloat) -> Text {
        switch font {
        case .Light:
            return self.font(.bitterLight(size: size))
        case .Regular:
            return self.font(.bitterRegular(size: size))
        case .Medium:
            return self.font(.bitterMedium(size: size))
        case .SemiBold:
            return self.font(.bitterMedium(size: size))
        case .Bold:
            return self.font(.bitterBold(size: size))
        }
    }
}

//MARK: - UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func toHexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

//MARK: - Color
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
    
    func toHexString() -> String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

//MARK: - Set<AnyCancellable>
typealias AnyCancellablesSet = Set<AnyCancellable>

extension AnyCancellablesSet {
    mutating func cancelAll() {
        forEach { $0.cancel() }
        removeAll()
    }
}

//MARK: - Data
extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    //to get extension of image
    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpeg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}

//MARK: - Date
extension Date {
    func convertDate(toFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getTimeDifferenceFrom(_ endTime: Date, withComponents components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self, to: endTime)
    }
}

//MARK: - String
extension String {
    func trim() -> Self {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func removeCharacter(_ character: String) -> String{
        return self.replacingOccurrences(of: character, with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        return !self.isEmpty && self.trim().count >= 7 && self.trim().count <= 10
    }
    
    func isValidPassword() -> Bool {
        return !self.isEmpty && self.count >= 6
    }
    
    var isValidBankAccount: Bool {
        return self.count >= 9 && self.count <= 18
    }
    
    var isValidIFSC: Bool {
        return self.count == 11
    }
    
    func containsPhoneNumber() -> Bool {
        do {
            let patt = "1?([2-9][0-8][0-9])([2-9][0-9]{2})([0-9]{4})(x?t?())?"
            let regPhn = "\\(?\\d{3}\\)?[.-]? *\\d{3}[.-]? *[.-]?\\d{4}"
            let regPhn2 = "(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}?"
            let regPhn3="(\\+\\d{1,3}( )?)?((\\(\\d{1,3}\\))|\\d{1,3})[- .]?\\d{3,4}[- .]?\\d{4}"
            let regex = try NSRegularExpression(pattern: patt)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            let phoneNumber = results.map { nsString.substring(with: $0.range)}
            let regex2 = try NSRegularExpression(pattern: regPhn)
            let results2 = regex2.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            let phoneNumber2 = results2.map { nsString.substring(with: $0.range)}
            let regex3 = try NSRegularExpression(pattern: regPhn2)
            let results3 = regex3.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            let phoneNumber3 = results3.map { nsString.substring(with: $0.range)}
            let regex4 = try NSRegularExpression(pattern: regPhn3)
            let results4 = regex4.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            let phoneNumber4 = results4.map { nsString.substring(with: $0.range)}
            if (phoneNumber.isEmpty && phoneNumber2.isEmpty && phoneNumber3.isEmpty && phoneNumber4.isEmpty) {
                return false
            } else {
            return true
            }
        } catch let error {
            print("error in \(#function): \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - date and time related functions
    func getDateFromStringDate(withFormat format: String) -> Date {
        let olDateFormatter = DateFormatter()
        olDateFormatter.calendar = Calendar(identifier: .gregorian)
        olDateFormatter.dateFormat = format
        olDateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return olDateFormatter.date(from: self) ?? Date()
    }
    
    func getDateFromServerStringDate() -> Date {
        return self.getDateFromStringDate(withFormat: DateFormats.serverDF)
    }
    
    func convertServerStringDate(toFormat format: String) -> Self {
        return convertStringDate(withFormat: DateFormats.serverDF, toFormat: format)
    }
    
    func convertStringDate(withFormat: String, toFormat: String) -> Self {
        let date = self.getDateFromStringDate(withFormat: withFormat)
        return date.convertDate(toFormat: toFormat)
    }
    
    func convertStringDateFormatFromFirebase(withFormat: String = DateFormats.firebaseDF, toFormat: String) -> String {
        //E MMM d yyyy HH:mm:ss Z
        //EEE MMM dd yyyy HH:mm:ss
        //EEE MMM dd yyyy HH:mm:ss ZZZ
        //        let conDate1 = inputDate.replacingOccurrences(of: " (Coordinated Universal Time)", with: "")
        let conDate1 = String(self.prefix(33))
        let conDate = conDate1.replacingOccurrences(of: "GMT", with: "")
        //        let conDate = String(inputDate.prefix(24))
        return conDate.convertStringDate(withFormat: DateFormats.firebaseDF, toFormat: toFormat)
    }
}

//MARK: - Double
extension Double {
    func secondsToHoursMinutesAndSecondsFormat(withTimeUnit: Bool) -> String {
        guard !(self.isNaN || self.isInfinite) else {
            return "00:00"
        }
        
        let hour = Int(self) / 3600
        let minute = Int(self) / 60 % 60
        let second = Int(self) % 60
        if hour == 0 {
            let time = String(format: "%02i:%02i", minute, second)
            if withTimeUnit {
                let substring = minute > 1 ? AppTexts.minutes : AppTexts.minute
                return time + " " + substring
            }
            return time
        } else {
            let time = String(format: "%02i:%02i:%02i", hour, minute, second)
            if withTimeUnit {
                let substring = hour > 1 ? AppTexts.hours : AppTexts.hour
                return time + " " + substring
            }
            return time
        }
    }
    
    /// Rounds the double to decimal places value
    func round(toPlaces place: Int = 2) -> Double {
        //1.256 to 1.26
        let divisor = pow(10.0, Double(place))
        return (self * divisor).rounded() / divisor
    }
    
    func calculateGST() -> Self {
        return ((18 * self) / 100).round()
    }
    
    func format(withCurrency: Bool = false, withMaximumFractionDigits maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        if withCurrency {
            //formatter.locale = NSLocale.currentLocale() Locale(identifier: "es_IN")
            formatter.locale = Singleton.sharedInstance.generalFunctions.getLocale()
            formatter.numberStyle = .currency
        }
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maximumFractionDigits //maximum digits in Double after dot (maximum precision)
        
        let price = self as NSNumber
        return formatter.string(from: price) ?? ""
    }
    
    func doubleToString(places: Int = 2) -> String {
        return String(format: "%.\(places)f", self)
    }
    
    func getNumberWords() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        //formatter.locale = Singleton.sharedInstance.generalFunctions.getLocale()
        let number = self as NSNumber
        return formatter.string(for: number) ?? ""
    }
}
