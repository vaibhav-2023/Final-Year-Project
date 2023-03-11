//
//  ListFooterProgressView.swift
//  payment_app
//
//  Created by MacBook PRO on 11/01/23.
//

import SwiftUI

//Loader to show in the footer of list view when list is loading
struct ListFooterProgressView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView().padding(.top)
            Spacer()
        }.listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .buttonStyle(PlainButtonStyle())
    }
}

struct ListFooterProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ListFooterProgressView()
    }
}
