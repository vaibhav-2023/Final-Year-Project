//
//  ChatScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct ChatScreen: View {
    
    @StateObject private var userDetailsVM = UserDetailsViewModel()
    
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var textViewHeight: CGFloat = 34
    @State private var messageText: String = ""
    
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
            
            VStack(spacing: spacing) {
                ScrollViewReader { scrollViewReader in
                    List {
                        MessageCell(message: "My Message", isSent: true)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                        //.id(index)
                            .buttonStyle(PlainButtonStyle())
                            .padding([.top, .horizontal], padding/2)
                        MessageCell(message: "My Message", isSent: false)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                        //.id(index)
                            .buttonStyle(PlainButtonStyle())
                            .padding([.top, .horizontal], padding/2)
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
            .onAppear {
                if userDetailsVM.userDetails == nil, let payToUserModel {
                    userDetailsVM.setUserDetails(payToUserModel)
                }
                userDetailsVM.getDetailsOfUser()
            }
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen(payToUserModel: nil)
    }
}
