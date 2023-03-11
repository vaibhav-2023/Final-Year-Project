//
//  AppTexts.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation

//All App Texts used in app are stored in this file created on 31/12/22
class AppTexts {
    //common
    static let minute = "Minute"
    static let minutes = "Minutes"
    static let hour = "Hour"
    static let hours = "Hours"
    static let mobileNumber = "Mobile Number"
    static let save = "Save"
    static let proceed = "Proceed"
    static let optional = "Optional"
    static let cancel = "Cancel"
    static let noDataAvailable = "No Data Available"
    static let noBanksFound = "No Banks Found"
    static let noUsersFound = "No Users Found"
    static let noTransactionsFound = "No Transactions Found"
    static let noBankAccountsAdded = "No Bank Accounts Added"
    static let willBeAddedSoon = "Will be Added Soon"
    static let thisApp = "This app"
    
    //login
    static let enterYourMobileNumberToContinue = "Enter your mobile number to continue"
    static let login = "Login"
    
    //otp
    static let verifyOTP = "Verify OTP"
    static let enterOTPSendToYourMobileNumber = "Enter OTP that was send to your Mobile Number"
    static let verify = "Verify"
    static let didNotReceiveOTPQuestionMark = "Did not Receive OTP?"
    static let resendOTP = "Resend OTP"
    
    //fill details
    static let fillDetails = "Fill Details"
    static let enterYourDetails = "Enter your details"
    static let tellUsAboutYourself = "Tell us about yourself"
    static let yourName = "Your Name"
    static let yourEmail = "Your Email"
    
    //fill bank details
    static let bankDetails = "Bank Details"
    static let skip = "Skip"
    static let addBankDetailsForVerification = "Add bank details for verification"
    static let changeBank = "Change Bank"
    static let selectBank = "Select Bank"
    static let selected = "Selected"
    static let bank = "Bank"
    static let bankAccount = "Bank Account"
    static let ifsc = "IFSC"
    
    //fill bank transfer details
    static let accountNumber = "Account Number"
    static let reenterAccountNumber = "Re-enter Account Number"
    static let receipientName = "Receipient Name"
    
    //home
    static let home = "Home"
    static let greetings = "Greetings"
    static let upiID = "UPI ID"
    static let payTo = "Pay to"
    static let scan = "Scan"
    static let qr = "QR"
    static let scanQR = "Scan QR"
    static let contact = "Contact"
    static let transfer = "Transfer"
    static let selfString = "Self"
    static let number = "Number"
    static let walletTransactions = "Wallet Transactions"
    static let checkBalance = "Check Balance"
    
    //wallet transaction
    static let failed = "Failed"
    
    //profile
    static let profile = "Profile"
    static let qrCode = "QR Code"
    static let bankAccounts = "Bank Accounts"
    static let privacyPolicy = "Privacy Policy"
    static let termsAndConditions = "Terms & Conditions"
    static let logout = "Logout"
    
    //profile info screen
    static let yourDetails = "Your Details"
    static let name = "Name"
    static let email = "Email"
    static let removeImage = "Remove Image"
    
    //pay to screen
    static let payToNumber = "Pay to number"
    static let payToUPIID = "Pay to UPI ID"
    static let payFrom = "Pay from"
    static let pay = "Pay"
    static let addBankAccount = "Add Bank Account"
    
    //payment details
    static let to = "To"
    static let from = "From"
    static let received = "Received"
    static let sent = "Sent"
    static let transactionID = "Transaction ID"
    static let ruppees = "Ruppees"
    static let ruppee = "Ruppee"
    static let only = "Only"
    
    //scan QR Code
    static let grantCameraAccessToScanQRCode = "Grant Camera Access to Scan QR Code"
    static let openSettings = "Open Settings"
    
    //qr code details
    static let selectedBank = "Selected Bank"
    
    //messages to be shown in alerts
    class AlertMessages {
        //common
        static let successWithExclamation = "Success!"
        static let errorWithExclamation = "Error!"
        static let invalidDetailsWithExclamation = "Invalid Details!"
        static let ok = "Ok"
        static let cancel = "Cancel"
        static let comingSoon = "Coming soon..."
        static let copiedToClipboard = "Copied to Clipboard"
        
        //network unreachable
        static let networkUnreachableWithExclamation = "Network Unreachable!"
        static let youAreNotConnectedToInternet = "You are not connected to Internet"
        static let tapToRetry = "Tap to Retry!"
        
        //session expired
        static let sessionExpiredWithExclamation = "Session Expired!"
        static let yourSessionHasExpiredPleaseLoginAgain = "Your Session has expired, PLease Login Again."
        
        //permission alerts
        static let accessDenied = "Access Denied"
        static let requiresAccessToContactsToProceed = "requires access to Contacts to proceed."
        static let requiresAccessToCameraToProceed = "requires access to Camera to proceed."
        static let goToSettingsToGrantAccess = "Go to Settings to grant access."
        static let openSettings = "Open Settings"
        
        //login
        static let enterMobileNumber = "Enter Mobile Number"
        static let enterValidMobileNumber = "Enter Valid Mobile Number"
        
        //otp
        static let enterOTP = "Enter OTP"
        static let enterValidOTP = "Enter Valid OTP"
        
        //fill details
        static let enterName = "Enter Name"
        static let enterEmail = "Enter Email"
        static let enterValidEmail = "Enter Valid Email"
        
        //fill bank details
        static let selectBank = "Select Bank"
        static let enterBankAccount = "Enter Bank Account"
        static let enterValidBankAccount = "Enter valid Bank Account"
        static let enterIFSC = "Enter IFSC"
        static let enterValidIFSC = "Enter valid IFSC"
        
        //payment screen
        static let amountShouldBeAtleast = "Amount Should be alteast"
        
        //bank tranfer screen
        static let enterAccountNumber = "Enter Account Number"
        static let enterValidAccountNumber = "Enter valid Account Number"
        static let reenterAccountNumber = "Re-enter Account Number"
        static let accountNumberDoesNotMatch = "Account Number does not match"
        static let enterRecipientName = "Enter Recipient Name"
        
        //profile info screen
        static let selectImageFrom = "Select Image From"
        static let camera = "Camera"
        static let photoLibrary = "Photo Library"
        
        //logout
        static let areYouSureYouWantToLogoutFromApp = "Are you sure you want to logout from app"
    }
    
    //placeholders to be shown in textfields
    class TextFieldPlaceholders {
        static let search = "Search"
        
        static let enterMobileNumber = "Enter Mobile Number"
        static let enterYourName = "Enter your Name"
        static let enterYourEmail = "Enter your Email"
        
        static let selectBank = "Select Bank"
        static let enterBankAccount = "Enter Bank Account"
        static let enterIFSC = "Enter IFSC"
        
        static let enterAMessage = "Enter a message"
        
        static let noteIfAny = "Note if any"
        
        static let enterAccountNumber = "Enter Account Number"
        static let reenterAccountNumber = "Re-enter Account Number"
        static let enterReceipientName = "Enter Receipient Name"
    }
}
