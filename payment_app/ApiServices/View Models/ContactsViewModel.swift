//
//  ContactsViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import Foundation
import ContactsUI
import Combine

//View Model to handle contacts permissions created on 07/01/23
class ContactsViewModel: ViewModel {
    
    @Published var hasGrantedRequest: Bool = false
    @Published var hasSharedContacts: Bool = false
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var contacts: [ContactsModel] = []
    var count: Int = 0
    var apiStatus: ApiStatus = .NotHitOnce
    
    //request for contact permission
    func requestAccess(sendContacts: Bool) {
        let contactStore = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            handleAllowedCase()
            print("in Contacts .authorized")
        case .denied:
            handleDeniedRestrictedCase()
            print("in Contacts .denied")
        case .restricted:
            handleDeniedRestrictedCase()
            print("in Contacts .restricted")
        case .notDetermined:
            //if permission is not determined then request for permission
            contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
                if granted {
                    DispatchQueue.main.async {
                        self?.hasGrantedRequest = false
                    }
                    print("in Contacts user Allowed Access")
                } else {
                    self?.handleDeniedRestrictedCase()
                    print("in Contacts user Denied Access")
                }
            }
            print("in Contacts .notDetermined")
        @unknown default:
            print("in Contacts @unknown default")
        }
    }
    
    
    private func handleDeniedRestrictedCase() {
        DispatchQueue.main.async {
            self.hasGrantedRequest = false
        }
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                self.showSettingsAlert()
        //            }
    }
    
    //if user has not given camera, we show the open app settings option with this method
    private func showSettingsAlert() {
        let alert = Singleton.sharedInstance.alerts.getAlertController(ofStyle: .alert,
                                                   withTitle: AppTexts.AlertMessages.accessDenied,
                                                                       andMessage: (AppInfo.appName ?? AppTexts.thisApp) +
                                                                       " " + AppTexts.AlertMessages.requiresAccessToContactsToProceed +
                                                                       " " + AppTexts.AlertMessages.goToSettingsToGrantAccess)
        
        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.openSettings, style: .default) { action in
            Singleton.sharedInstance.generalFunctions.openAppSettings()
        })
        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.cancel, style: .cancel, handler: nil))
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    private func handleAllowedCase() {
        //if sendContacts && self.apiStatus == .NotHitOnce {
        if self.apiStatus == .NotHitOnce {
            self.getContacts()
        }
        DispatchQueue.main.async {
            self.hasGrantedRequest = true
        }
    }
    
    //if user has given the permission then get all the contacts from user device
    private func getContacts() {
        let keys = [CNContactVCardSerialization.descriptorForRequiredKeys()] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        let contactStore = CNContactStore()
        
        self.contacts.removeAll()
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                for phoneNumber in contact.phoneNumbers {
                    if let phoneNumberAsString = (phoneNumber.value).value(forKey: "digits") as? String {
                        let name = "\(contact.givenName) \(contact.familyName)".trim()
                        let contactModel = ContactsModel(name: name, number: phoneNumberAsString)
                        self.contacts.append(contactModel)
                        print("The \(phoneNumber.label ?? "") number of \(name) is: \(phoneNumberAsString)")
                    }
                }
            }
            print("completed")
            
            self.sendContacts()
        }
        catch {
            print("unable to fetch contacts in \(#function)")
        }
    }
    
    //send contacts to server, in 500-500 packets, so that server must not crash with amount of contacts
    private func sendContacts() {
        apiStatus = .IsBeingHit
        
        let range = 500
        var contactsToSend: [ContactsModel] = []
        
        if contacts.count > (range - 1) {
            let startIndex = range * count
            let endIndex = (range * (count + 1)) - 1
            if contacts.count > endIndex {
                contactsToSend = Array(contacts[startIndex...endIndex])
            } else {
                contactsToSend = Array(contacts[startIndex...(contacts.count - 1)])
            }
        } else {
            contactsToSend = contacts
        }
        
        if let contactModel = Singleton.sharedInstance.generalFunctions.structToJSON(contactsToSend) {
            let params = ["contacts": contactModel] as JSONKeyPair
            
            var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .sendContacts)
            urlRequest?.addHeaders(shouldAddAuthToken: true)
            urlRequest?.addParameters(params, as: .URLFormEncoded)
            Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: BaseResponse.self) { [weak self] in
                    self?.sendContacts()
                }
                .sink{ [weak self] completion in
                    switch completion {
                        case .finished:
                        break
                        case .failure(_):
                        self?.apiStatus = .ApiHitWithError
                        break
                    }
                } receiveValue: { [weak self] baseResponse in
                    guard let self = self else { return }
                    if baseResponse.success == true {
                        if self.contacts.count > (range * (self.count + 1)) - 1 {
                            self.count += 1
                            self.sendContacts()
                        } else {
                            self.count = 0
                            self.hasSharedContacts = true
                        }
                        self.apiStatus = .ApiHit
                    } else {
                        self.apiStatus = .ApiHitWithError
                    }
                }.store(in: &cancellable)
        }
    }
    
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}

