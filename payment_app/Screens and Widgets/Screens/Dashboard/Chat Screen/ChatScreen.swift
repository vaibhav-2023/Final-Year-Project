//
//  ChatScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct ChatScreen: View {
    
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var textViewHeight: CGFloat = 34
    @State private var messageText: String = ""
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        VStack(spacing: spacing) {
            ScrollViewReader { scrollViewReader in
                List {
                    MessageCell(message: "My Message", isSent: true)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                    //.id(index)
                        .buttonStyle(PlainButtonStyle())
                    MessageCell(message: "My Message", isSent: false)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                    //.id(index)
                        .buttonStyle(PlainButtonStyle())
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
                MinWidthButton(text: AppTexts.pay.uppercased(), fontEnum: .Medium, textSize: 18) {
                    
                }
                
                LoginFieldsOuterView(addFrameHeight: false, addPadding: false) {
                    MyTextView(AppTexts.TextFieldPlaceholders.enterAMessage, text: $messageText, isAdjustableTV: true, adjustableTVHeight: $textViewHeight)
                        .padding(.vertical, 4)
                }
                
                VStack {
                    Button {
                        print(messageText)
                    } label: {
                        ImageView(imageName: "sendIconTemplate", isSystemImage: false)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(messageText.trim().isEmpty ? .darkGrayColor : .primaryColor)
                    }
                }.frame(height: 45)
            }.padding(padding)
            .background(Color.lightBluishGrayColor.ignoresSafeArea(edges: .bottom))
        }.background(Color.whiteColor.ignoresSafeArea())
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen()
    }
}
