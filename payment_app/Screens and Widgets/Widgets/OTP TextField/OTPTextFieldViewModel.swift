//
//  OTPTextFieldViewModel.swift
//  gulati_handlom
//
//  Created by MacBook Pro on 24/01/22.
//

import Foundation
import SwiftUI

class OTPTextFieldViewModel: ObservableObject {
    
    @Published private(set) var borderColor: Color = .blackColor
    @Published private(set) var isTextFieldDisabled = false
    @Published private(set) var showResendText = false
    @Published var otpField = "" {
        didSet {
            guard otpField.count <= 4,
                  otpField.last?.isNumber ?? true else {
                otpField = oldValue
                return
            }
        }
    }
    
    var successCompletionHandler: (()->())?
    
    var otp1: String {
        guard otpField.count >= 1 else {
            return ""
        }
        return String(Array(otpField)[0])
    }
    
    var otp2: String {
        guard otpField.count >= 2 else {
            return ""
        }
        return String(Array(otpField)[1])
    }
    
    var otp3: String {
        guard otpField.count >= 3 else {
            return ""
        }
        return String(Array(otpField)[2])
    }
    
    var otp4: String {
        guard otpField.count >= 4 else {
            return ""
        }
        return String(Array(otpField)[3])
    }
}
