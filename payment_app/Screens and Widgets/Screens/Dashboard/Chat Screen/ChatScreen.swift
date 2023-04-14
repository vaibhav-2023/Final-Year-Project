//
//  ChatScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct ChatScreen: View {
    
    //environment variable to pop the screen
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //For Observing View Model added on 17/01/23
    @StateObject private var userDetailsVM = UserDetailsViewModel()
    @StateObject private var chatVM = ChatViewModel()
    
    //Variables used for view
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var textViewHeight: CGFloat = 34
    @State private var messageText: String = ""
    @State private var selectedWalletTransaction: WalletTransactionModel? = nil
    
    //variable used for navigation
    @State private var selection: Int? = nil
    
    //constants for spacing and padding
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    //value received from previous screen
    private let payToUserModel: UserModel?
    
    init(payToUserModel: UserModel?) {
        self.payToUserModel = payToUserModel
    }
    
    //View to be shown
    var body: some View {
        ZStack {
            NavigationLink(destination: PayToScreen(payToUserModel: userDetailsVM.userDetails), tag: NavigationEnum.PayToScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            NavigationLink(destination: PaymentDetailsScreen(walletTransactionsDetails: selectedWalletTransaction), tag: NavigationEnum.PaymentDetailsScreen.rawValue, selection: $selection) {
                EmptyView()
            }
            
            VStack(spacing: spacing) {
                let count = chatVM.chatWalletTransactions.count
                //if api is hit and chat messages are empty show empty view
                if chatVM.getChatWalletTransactionsAS == .ApiHit && count == 0 {
                    EmptyListView(text: AppTexts.noTransactionsFound)
                } else if count != 0 {
                    //if chat messages are not empty show all
                    ScrollViewReader { scrollViewReader in
                        List {
                            ForEach(Array((chatVM.chatWalletTransactions.reversed()).enumerated()), id: \.1) { index, chatWalletTransaction in
                                //updated on 10/04/23
                                let isDebit = Singleton.sharedInstance.generalFunctions.getUserID() == chatWalletTransaction?.getPaidByUserModel?.id
                                let isPayment = true
                                Group {
                                    //if the message invloves info related to payment, on click open transactions dettails
                                    if isPayment {
                                        Button {
                                            selection = NavigationEnum.PaymentDetailsScreen.rawValue
                                            selectedWalletTransaction = chatWalletTransaction
                                        } label: {
                                            MessageCell(chatWalletTransaction: chatWalletTransaction,
                                                        isSent: isDebit,
                                                        isPayment: isPayment)
                                        }
                                    } else {
                                        MessageCell(chatWalletTransaction: chatWalletTransaction,
                                                    isSent: isDebit,
                                                    isPayment: isPayment)
                                    }
                                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowBackground(Color.clear)
                                    .id(index)
                                    .buttonStyle(PlainButtonStyle())
                                    .padding([.top, .horizontal], padding/2)
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
                                //scroll to last index, i.e., at the bottom of the view
                                self.scrollViewReader?.scrollTo(chatVM.chatWalletTransactions.count - 1)
                            }
                    }
                } else {
                    Spacer()
                }
                
                HStack(alignment: .bottom, spacing: spacing) {
                    MaxWidthButton(text: AppTexts.pay.uppercased(), fontEnum: .Medium, textSize: 18) {
                        selection = NavigationEnum.PayToScreen.rawValue
                    }
//                    MinWidthButton(text: AppTexts.pay.uppercased(), fontEnum: .Medium, textSize: 18) {
//                        
//                    }
                    
//                    LoginFieldsOuterView(addFrameHeight: false, addPadding: false) {
//                        MyTextView(AppTexts.TextFieldPlaceholders.enterAMessage, text: $messageText, isAdjustableTV: true, adjustableTVHeight: $textViewHeight)
//                            .padding(.vertical, 4)
//                    }
//
//                    VStack {
//                        Button {
//                            print(messageText)
//                        } label: {
//                            ImageView(imageName: "sendIconTemplate", isSystemImage: false)
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 30, height: 30)
//                                .foregroundColor(messageText.trim().isEmpty ? .darkGrayColor : .primaryColor)
//                        }
//                    }.frame(height: 45)
                }.padding(padding)
                    .background(Color.lightBluishGrayColor.ignoresSafeArea(edges: .bottom))
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .showLoader(isPresenting: .constant(userDetailsVM.isAnyApiBeingHit || chatVM.isAnyApiBeingHit))
            .navigationBarItems(leading: navigationBarLeadingView)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                //set user details to view model added on 17/01/23
                if userDetailsVM.userDetails == nil, let payToUserModel {
                    userDetailsVM.setUserDetails(payToUserModel)
                }
                //get details of other user
                userDetailsVM.getDetailsOfUser()
                //get chat messages
                chatVM.getChatWalletTransactionsWith(secondUserID: userDetailsVM.userDetails?.id ?? "")
            }
    }
    
    //set user image view, name etc in app bar/nav bar
    private var navigationBarLeadingView: some View {
        HStack(spacing: spacing) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.primaryColor)
            }
            
            let name = (userDetailsVM.userDetails?.name ?? "").capitalized
            AvatarView(imageURL: userDetailsVM.userDetails?.profilePic ?? "",
                       character: String(name.first ?? " "),
                       size: 35)
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .fontCustom(.Medium, size: 16)
                    .foregroundColor(.blackColor)
                
                let mobileNumber = (userDetailsVM.userDetails?.numericCountryCode ?? "") + " " + (userDetailsVM.userDetails?.phone ?? "")
                Text(mobileNumber)
                    .fontCustom(.Medium, size: 16)
                    .foregroundColor(.blackColor)
            }
            Spacer(minLength: 1)
        }.frame(width: DeviceDimensions.width * 0.6)
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen(payToUserModel: nil)
    }
}
