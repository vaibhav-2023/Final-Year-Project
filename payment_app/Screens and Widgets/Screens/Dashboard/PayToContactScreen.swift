//
//  PayToContactScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 17/01/23.
//

import SwiftUI

struct PayToContactScreen: View {
    
    //View Model used to send contacts
    @StateObject private var contactVM = ContactsViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                contactVM.requestAccess(sendContacts: false)
            }
    }
}

struct PayToContactScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToContactScreen()
    }
}
