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
    
    @Published var cnAuthorizationStatus: CNAuthorizationStatus = .notDetermined
    @Published var hasFetchedAddContacts: Bool = false
    @Published var hasSharedContacts: Bool = false
    @Published var contactsToShow: [ContactModel] = []
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var contacts: [ContactModel] = []
    var count: Int = 0
    var apiStatus: ApiStatus = .NotHitOnce
    
    //request for contact permission
    func requestAccess(sendContacts: Bool) {
        let contactStore = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            print("in Contacts .authorized")
            handleCaseForAuthorizationStatus(.authorized)
        case .denied:
            print("in Contacts .denied")
            handleCaseForAuthorizationStatus(.denied)
        case .restricted:
            print("in Contacts .restricted")
            handleCaseForAuthorizationStatus(.restricted)
        case .notDetermined:
            //if permission is not determined then request for permission
            contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
                if granted {
                    self?.handleCaseForAuthorizationStatus(.authorized)
                    print("in Contacts user Allowed Access")
                } else {
                    self?.handleCaseForAuthorizationStatus(.denied)
                    print("in Contacts user Denied Access")
                }
            }
            print("in Contacts .notDetermined")
        @unknown default:
            print("in Contacts @unknown default")
        }
    }
    
    
    private func handleCaseForAuthorizationStatus(_ cnAuthorizationStatus :CNAuthorizationStatus) {
            self.cnAuthorizationStatus = cnAuthorizationStatus
            if self.cnAuthorizationStatus == .authorized {
                self.getContacts()
            }
    }
    
    //if user has given the permission then get all the contacts from user device
    private func getContacts() {
        DispatchQueue.global(qos: .userInitiated).async {
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            let contactStore = CNContactStore()
            
            self.contacts.removeAll()
            
            let userNumber = Singleton.sharedInstance.generalFunctions.getUserModel()?.phone ?? ""

            do {
                try contactStore.enumerateContacts(with: request) { (contact, stop) in
                    
                        for phoneNumber in contact.phoneNumbers {
                            if let phoneNumberAsString = (phoneNumber.value).value(forKey: "digits") as? String, !phoneNumberAsString.contains(userNumber) {
                                let name = "\(contact.givenName) \(contact.familyName)".trim()
                                let contactModel = ContactModel(name: name, number: phoneNumberAsString)
                                self.contacts.append(contactModel)
                                //print("The \(phoneNumber.label ?? "") number of \(name) is: \(phoneNumberAsString)")
                            }
                        }
                    }
                
                DispatchQueue.main.async {
                    self.contacts = self.contacts.sorted { $0.name < $1.name }
                    self.hasFetchedAddContacts = true
                }
                
                
                //self.sendContacts()
            } catch {
                print("unable to fetch contacts in \(#function)")
            }
        }
    }
    
    //send contacts to server, in 500-500 packets, so that server must not crash with amount of contacts
//    private func sendContacts() {
//        apiStatus = .IsBeingHit
//
//        let range = 500
//        var contactsToSend: [ContactModel] = []
//
//        if contacts.count > (range - 1) {
//            let startIndex = range * count
//            let endIndex = (range * (count + 1)) - 1
//            if contacts.count > endIndex {
//                contactsToSend.append(contentsOf: Array(contacts[startIndex...endIndex]))
//            } else {
//                contactsToSend.append(contentsOf: Array(contacts[startIndex...(contacts.count - 1)]))
//            }
//        } else {
//            contactsToSend.append(contentsOf: contacts)
//        }
//
//        if let contactModel = Singleton.sharedInstance.generalFunctions.structToJSON(contactsToSend) {
//            let params = ["contacts": contactModel] as JSONKeyPair
//
//            var urlRequest = Singleton.sharedInstance.apiServices.getURL(ofHTTPMethod: .POST, forAppEndpoint: .sendContacts)
//            urlRequest?.addHeaders(shouldAddAuthToken: true)
//            urlRequest?.addParameters(params, as: .URLFormEncoded)
//            Singleton.sharedInstance.apiServices.hitApi(withURLRequest: urlRequest, decodingStruct: BaseResponse.self) { [weak self] in
//                    self?.sendContacts()
//                }
//                .sink{ [weak self] completion in
//                    switch completion {
//                        case .finished:
//                        break
//                        case .failure(_):
//                        self?.apiStatus = .ApiHitWithError
//                        break
//                    }
//                } receiveValue: { [weak self] baseResponse in
//                    guard let self = self else { return }
//                    if baseResponse.success == true {
//                        if self.contacts.count > (range * (self.count + 1)) - 1 {
//                            self.count += 1
//                            self.sendContacts()
//                        } else {
//                            self.count = 0
//                            self.hasSharedContacts = true
//                        }
//                        self.apiStatus = .ApiHit
//                    } else {
//                        self.apiStatus = .ApiHitWithError
//                    }
//                }.store(in: &cancellable)
//        }
//    }
    
    func paginateContactWithIndex(_ index: Int, andSearchText searchText: String) {
        if index >= (contactsToShow.count - 6) {
            getContactsToShow(withSearchText: searchText, clearList: false)
        }
    }
    
    func getContactsToShow(withSearchText searchText: String, clearList: Bool = true) {
        let range = 50
        if clearList {
            count = 0
            contactsToShow.removeAll()
        }
        print("All Contacts = \(contacts.count)")
        print("Contacts To Show Before = \(contactsToShow.count)")
        if contactsToShow.count < contacts.count {
            if searchText.isEmpty {
                if contacts.count > (range - 1) {
                    let startIndex = range * count
                    let endIndex = (range * (count + 1)) - 1
                    if contacts.count > endIndex {
                        contactsToShow.append(contentsOf: Array(contacts[startIndex...endIndex]))
                    } else {
                        contactsToShow.append(contentsOf: Array(contacts[startIndex...(contacts.count - 1)]))
                    }
                } else {
                    contactsToShow.append(contentsOf: contacts)
                }
            } else {
                let filteredContacts = contacts.filter({ $0.name.contains(searchText) || $0.number.contains(searchText) })
                if filteredContacts.count > (range - 1) {
                    let startIndex = range * count
                    let endIndex = (range * (count + 1)) - 1
                    if filteredContacts.count > endIndex {
                        contactsToShow = Array(filteredContacts[startIndex...endIndex])
                    } else {
                        contactsToShow = Array(filteredContacts[startIndex...(filteredContacts.count - 1)])
                    }
                } else {
                    contactsToShow.append(contentsOf: filteredContacts)
                }
            }
            
            if self.contacts.count > (range * (self.count + 1)) - 1 {
                self.count += 1
            }
        }
        print("Contacts To Show After = \(contactsToShow.count)")
    }
    
    //if user has not given camera, we show the open app settings option with this method
    func showSettingsAlert() {
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
    func cancelAllCancellables() {
        cancellable.cancelAll()
    }
}

