//
//  PayToUPIIDScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI

struct PayToUPIIDScreen: View {
    
    //Variables used for view
    @State private var searchText: String = ""
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
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
            
            VStack(spacing: spacing) {
                SearchTextField(searchText: searchString)
                    .padding([.top, .horizontal], padding)
                    .disabled(true)
                EmptyListView(text: AppTexts.willBeAddedSoon)
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
