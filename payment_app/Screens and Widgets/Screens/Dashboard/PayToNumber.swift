//
//  PayToNumber.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct PayToNumber: View {
    
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
                    contactDetail(contactName: "DUMMY CONTACT")
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
    private func contactDetail(contactName: String) -> some View {
        let size = DeviceDimensions.width * 0.12
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                AvatarView(character: String(contactName.capitalized.first ?? " "), size: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(contactName)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    Text("9876543210")
                        .foregroundColor(.darkGrayColor)
                        .fontCustom(.Regular, size: 13)
                }
                
                Spacer()
            }.padding(.horizontal, padding)
            
            Rectangle()
                .fill(Color.blackColor)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.leading, padding + (size/2))
        }
    }
}

struct PayToNumber_Previews: PreviewProvider {
    static var previews: some View {
        PayToNumber()
    }
}
