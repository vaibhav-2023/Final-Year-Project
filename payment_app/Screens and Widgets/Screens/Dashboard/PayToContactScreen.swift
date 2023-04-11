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
    //added on 08/04/2023 to check wheather contact has vpa or not
    @StateObject private var userDetailsVM = UserDetailsViewModel()
    
    //Variables used for view
    @State private var searchText: String = ""
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var selection: Int? = nil
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination: PayToScreen(payToUserModel: userDetailsVM.userDetails), tag: NavigationEnum.PayToScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            switch contactVM.cnAuthorizationStatus {
            case .restricted, .denied:
                provideContactAccessView
            case .authorized:
                VStack(spacing: spacing) {
                    SearchTextField(searchText: $searchText, maxLength: 10, keyboardType: .default)
                        .padding([.top, .horizontal], padding)
                    
                    ScrollViewReader { scrollViewReader in
                        List {
                            ForEach(Array(contactVM.contactsToShow.enumerated()), id: \.1) { index, contactModel in
                                Button {
                                    userDetailsVM.getUser(withContactModel: contactModel)
                                } label: {
                                    contactDetail(contactModel: contactModel)
                                }.padding(.bottom, padding)
                                    .if(index == 0) { $0.padding(.top, padding) }
                                    .onAppear {
                                        print("Index = ", index)
                                        contactVM.paginateContactWithIndex(index, andSearchText: searchText)
                                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowBackground(Color.clear)
                                    .id(index)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }.listStyle(PlainListStyle())
                            .onTapGesture {
                                return
                            }
                            .onLongPressGesture(minimumDuration: 0.1) {
                                return
                            }.onAppear {
                                //update scroll view value in scroll view reader
                                self.scrollViewReader = scrollViewReader
                            }
                    }
                }
            default:
                EmptyView()
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.payToContact)
            .showLoader(isPresenting: .constant(userDetailsVM.userDetailsAS == .IsBeingHit))
            .onAppear {
                contactVM.requestAccess(sendContacts: false)
                userDetailsVM.setUserDetails(nil)
            }.onReceive(contactVM.$hasFetchedAddContacts) { hasFetchedAddContacts in
                if hasFetchedAddContacts {
                    contactVM.getContactsToShow(withSearchText: searchText, clearList: true)
                }
            }.onReceive(userDetailsVM.$userDetailsAS) { apiStatus in
                if apiStatus == .ApiHit && userDetailsVM.userDetails != nil {
                    selection = NavigationEnum.PayToScreen.rawValue
                }
            }.onChange(of: searchText) { text in
                if searchText.count > 3 {
                    contactVM.getContactsToShow(withSearchText: searchText, clearList: true)
                } else {
                    contactVM.getContactsToShow(withSearchText: "", clearList: true)
                }
            }
    }
    
    // request for contact access view
    private var provideContactAccessView: some View {
        ZStack {
            VStack(spacing: spacing) {
                Spacer()
                
                Text(AppTexts.grantContactAccessToViewContactsOnThisApp)
                    .foregroundColor(.blackColor)
                    .fontCustom(.Medium, size: 22)
                    .multilineTextAlignment(.center)
                
                MinWidthButton(text: AppTexts.openSettings, fontEnum: .Medium, textSize: 18, horizontalPadding: padding) {
                    contactVM.showSettingsAlert()
                }
                
                Spacer()
            }.padding(padding)
        }.background(Color.whiteColor.ignoresSafeArea())
    }
    
    //contact Detail View
    @ViewBuilder
    private func contactDetail(contactModel: ContactModel?) -> some View {
        let size = DeviceDimensions.width * 0.12
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                let name = (contactModel?.name ?? "").capitalized
                AvatarView(character: String(name.first ?? " "), size: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .fontCustom(.Medium, size: 16)
                        .foregroundColor(.blackColor)
                    
                    Text(contactModel?.number ?? "")
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

struct PayToContactScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayToContactScreen()
    }
}
