//
//  SelectBankScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct SelectBankScreen: View {
    
    @State private var searchText: String = ""
    
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
            
            VStack {
                SearchTextField(searchText: searchString)
                
                List {
                    bankDetail(bankName: "DUMMY BANK")
                        .buttonStyle(PlainButtonStyle())
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                }.listStyle(PlainListStyle())
                    .onTapGesture {
                        return
                    }
                    .onLongPressGesture(minimumDuration: 0.1) {
                        return
                    }
                
            }
        }.background(Color.whiteColor.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func bankDetail(bankName: String) -> some View {
        let size = DeviceDimensions.width * 0.12
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                AvatarView(character: String(bankName.capitalized.first ?? " "), size: size)
                
                Text(bankName)
                
                Spacer()
            }.padding(.horizontal, padding)
            
            Divider()
                .padding(.leading, padding + (size/2))
        }
    }
}

struct SelectBankScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankScreen()
    }
}
