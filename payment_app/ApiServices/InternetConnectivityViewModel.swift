//
//  InternetConnectivityViewModel.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import Network

class InternetConnectivityViewModel: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectivityMonitor")
    
    init() {
        checkConnection()
    }
    
    private func checkConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
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
