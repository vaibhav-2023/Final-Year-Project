//
//  PayToVPAIDScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI

struct PayToVPAIDScreen: View {
    
    //For Handling View Model added on 08/04/23
    @StateObject private var usersVM = UsersViewModel()
    
    //Variables used for view
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var searchText: String = ""
    @State private var selection: Int? = nil
    @State private var selectedUser: UserModel? = nil
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            NavigationLink(destination: PayToScreen(payToUserModel: selectedUser), tag: NavigationEnum.PayToScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            VStack(spacing: spacing) {
                SearchTextField(searchText: $searchText)
                    .padding([.top, .horizontal], padding)
                
                //if api is hit and users list is empty show empty view updated on 12/01/23
                if usersVM.getSearchedUsersAS == .ApiHit && usersVM.searchResultUsers.count == 0 {
                    EmptyListView(text: AppTexts.noUsersFound)
                } else if usersVM.searchResultUsers.count != 0 {
                    //if users list is not empty show all
                    ScrollViewReader { scrollViewReader in
                        List {
                            //updated on 12/01/23
                            Section(footer: !usersVM.fetchedAllData ?
                                    ListFooterProgressView()
                                    : nil) {
                                ForEach(Array(usersVM.searchResultUsers.enumerated()), id: \.1) { index, user in
                                    Button {
                                        selectedUser = user
                                        selection = NavigationEnum.PayToScreen.rawValue
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
                            }.onAppear {
                                self.scrollViewReader = scrollViewReader
                            }
                    }
                } else {
                    Spacer()
                }
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.payToVPAID)
            .onChange(of: searchText) { text in
                if searchText.count > 3 {
                    //updated on 12/01/23
                    usersVM.searchUsers(withMobileNumber: searchText, clearList: true)
                }
            }
    }
    
    //contact Detail View
    @ViewBuilder
    private func contactDetail(userDetail: UserModel?) -> some View {
        let size = DeviceDimensions.width * 0.12
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                let name = (userDetail?.name ?? "").capitalized
                AvatarView(imageURL: (userDetail?.profilePic ?? ""),
                    character: String(name.first ?? " "), size: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    Text(userDetail?.phone ?? "")
                        .foregroundColor(.darkGrayColor)
                        .fontCustom(.Regular, size: 13)
                }
                
                Spacer()
            }
            
            Rectangle()
                .fill(Color.blackColor)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.leading, padding + (size/2))
        }.padding(.horizontal, padding)
    }
}

struct PayToVPAIDScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToVPAIDScreen()
    }
}
