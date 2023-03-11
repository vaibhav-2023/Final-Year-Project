//
//  SearchTextFields.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

//Search Field created to perform search operations
struct SearchTextField: View {
    
    @State private var showCancelButton: Bool = false
    
    @Binding private var searchText: String
    
    private let maxLength: Int?
    private let keyboardType: UIKeyboardType
    
    init(searchText: Binding<String>,
         maxLength: Int? = nil,
         keyboardType: UIKeyboardType = UIKeyboardType.default) {
        self._searchText = searchText
        self.maxLength = maxLength
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                MyTextField(AppTexts.TextFieldPlaceholders.search, text: $searchText, maxLength: maxLength, keyboardType: keyboardType) { isEditing in
                    self.showCancelButton = isEditing
                }
                
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color.lightGray)
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button(AppTexts.cancel) {
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }//.navigationBarHidden(showCancelButton)
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(searchText: .constant(""))
    }
}
