//
//  HomeScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct HomeScreen: View {
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: spacing) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: spacing) {
                                Text(AppTexts.greetings + ",")
                                    .fontCustom(.SemiBold, size: 30)
                                    .foregroundColor(.blackColorForAllModes)
                                
                                Text("Dummy Name")
                                    .fontCustom(.Medium, size: 16)
                                    .foregroundColor(.blackColorForAllModes)
                            }
                            
                            Spacer()
                            
                            AvatarView(character: "D")
                        }
                        
                        HStack {
                            Text("\(AppTexts.mobileNumber)")
                                .fontCustom(.Medium, size: 16)
                            
                            
                            
                        }.padding(.top, padding)
                        
                    }.padding(.top, padding * 2)
                        .padding(.horizontal, padding)
                        .padding(.bottom, padding / 2)
                        .background(LinearGradient(gradient: Gradient(colors: [.lightPrimaryColor, .lightBluishGrayColor]), startPoint: .top, endPoint: .bottom))
                    
                    CardView(backgroundColor: .lightBluishGrayColor) {
                        VStack(spacing: spacing) {
                            
                        }
                    }.padding(padding)
                    
                }
            }
        }
        .background(Color.whiteColor.ignoresSafeArea())
    }
    
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
