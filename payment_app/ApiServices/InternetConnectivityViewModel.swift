//
//  InternetConnectivityViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import Network

//view model to have a check on internet connectivity created on 31/12/22
class InternetConnectivityViewModel: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectivityMonitor")
    
    //whenever the class constructor is called initiate the Observer
    init() {
        checkConnection()
    }
    
    private func checkConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                //update status if internet is accessible or not
                if path.status == .satisfied {
                    Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet = true
                } else {
                    Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
