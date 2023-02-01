//
//  PayToUPIIDScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI

struct PayToUPIIDScreen: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            let searchString = Binding<String>(get: {
                self.searchText
            }, set: {
                self.searchText = $0
                if searchText.count > 1 {
                    let searchText = searchText.lowercased()
                    //countriesToShow = countryViewModel.countries.filter { $0.name?.lowercased().contains(searchText) == true }
                } else {
                    //countriesToShow = countryViewModel.countries
                }
            })
            
            VStack {
                SearchTextField(searchText: searchString)
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.payToUPIID)
    }
}

struct PayToUPIIDScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToUPIIDScreen()
    }
}
