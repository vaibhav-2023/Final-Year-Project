//
//  ChatScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct ChatScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var userDetailsVM = UserDetailsViewModel()
    @StateObject private var chatVM = ChatViewModel()
    
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var textViewHeight: CGFloat = 34
    @State private var messageText: String = ""
    @State private var selectedWalletTransaction: WalletTransactionModel? = nil
    
    @State private var selection: Int? = nil
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    private let payToUserModel: UserModel?
    
    init(payToUserModel: UserModel?) {
        self.payToUserModel = payToUserModel
    }
    
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
                if chatVM.getChatWalletTransactionsAS == .ApiHit && count == 0 {
                    EmptyListView(text: AppTexts.noTransactionsFound)
                } else if count != 0 {
                    ScrollViewReader { scrollViewReader in
                        List {
                            ForEach(Array((chatVM.chatWalletTransactions.reversed()).enumerated()), id: \.1) { index, chatWalletTransaction in
                                let isDebit = Singleton.sharedInstance.generalFunctions.getUserID() ==  chatWalletTransaction?.paidByUserID?.id
                                let isPayment = true
                                Group {
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
                                self.scrollViewReader = scrollViewReader
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
                if userDetailsVM.userDetails == nil, let payToUserModel {
                    userDetailsVM.setUserDetails(payToUserModel)
                }
                userDetailsVM.getDetailsOfUser()
                chatVM.getChatWalletTransactionsWith(secondUserID: userDetailsVM.userDetails?.id ?? "")
            }
    }
    
    private var navigationBarLeadingView: some View {
        HStack(spacing: spacing) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.primaryColor)
            }
            
            let name = (userDetailsVM.userDetails?.name ?? "").capitalized
            AvatarView(character: String(name.first ?? " "), size: 35)
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .fontCustom(.Medium, size: 16)
                    .foregroundColor(.blackColor)
                
                let mobileNumber = (userDetailsVM.userDetails?.numericCountryCode ?? "") + " " + (userDetailsVM.userDetails?.phone ?? "")
                Text(mobileNumber)
                    .fontCustom(.Medium, size: 16)
                    .foregroundColor(.blackColor)
            }
        }
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen(payToUserModel: nil)
    }
}
