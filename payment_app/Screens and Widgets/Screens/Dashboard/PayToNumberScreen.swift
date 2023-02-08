//
//  PayToNumber.swift
//  payment_app
//
//  Created by MacBook PRO on 05/01/23.
//

import SwiftUI

struct PayToNumberScreen: View {
    
    @StateObject private var usersVM = UsersViewModel()
    
    @State private var searchText: String = ""
    @State private var selection: Int? = nil
    @State private var selectedUser: UserModel? = nil
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination: ChatScreen(payToUserModel: selectedUser), tag: NavigationEnum.ChatScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            VStack {
                SearchTextField(searchText: $searchText, maxLength: 10, keyboardType: .numberPad)
                    .padding(.top, padding)
                
                if usersVM.getSearchedUsersAS == .ApiHit && usersVM.searchResultUsers.count == 0 {
                    EmptyListView(text: AppTexts.noUsersFound)
                } else if usersVM.searchResultUsers.count != 0 {
                    List {
                        Section(footer: !usersVM.fetchedAllData ?
                                ListFooterProgressView()
                                : nil) {
                            ForEach(Array(usersVM.searchResultUsers.enumerated()), id: \.1) { index, user in
                                Button {
                                    selectedUser = user
                                    selection = NavigationEnum.ChatScreen.rawValue
                                } label: {
                                    contactDetail(userDetail: user)
                                }.padding(.bottom, padding)
                                    .if(index == 0) { $0.padding(.top, padding) }
                                    .onAppear {
                                        usersVM.paginateWithIndex(index, andSearchText: searchText)
                                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowBackground(Color.clear)
                                    .id(index)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }.listStyle(PlainListStyle())
                        .onTapGesture {
                            return
                        }
                        .onLongPressGesture(minimumDuration: 0.1) {
                            return
                        }
                } else {
                    Spacer()
                }
            }.padding(.horizontal, padding)
                .background(Color.whiteColor.ignoresSafeArea())
                .setNavigationBarTitle(title: AppTexts.payToNumber)
                .onChange(of: searchText) { text in
                    if searchText.count > 3 {
                        usersVM.searchUsers(withMobileNumber: searchText, clearList: true)
                    }
                }
        }
    }
    
    @ViewBuilder
    private func contactDetail(userDetail: UserModel?) -> some View {
        let size = DeviceDimensions.width * 0.12
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                let name = (userDetail?.name ?? "").capitalized
                AvatarView(character: String(name.first ?? " "), size: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    Text(userDetail?.phone ?? "")
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

struct PayToNumberScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToNumberScreen()
    }
}
