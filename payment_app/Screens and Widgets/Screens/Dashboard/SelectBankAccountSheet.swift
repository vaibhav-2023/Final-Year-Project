//
//  SelectBankAccountSheet.swift
//  payment_app
//
//  Created by MacBook PRO on 06/01/23.
//

import SwiftUI

struct SelectBankAccountSheet: View {
    
    @ObservedObject private var profileVM: ProfileViewModel
    
    @State private var scrollViewReader: ScrollViewProxy?
    
    @Binding private var isPresenting: Bool
    @Binding private var selectedBankAccount: UserAddedBankAccountModel?
    @Binding private var selection: Int?
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    init(profileVM: ProfileViewModel,
         isPresenting: Binding<Bool>,
         selectedBankAccount: Binding<UserAddedBankAccountModel?>,
         selection: Binding<Int?>) {
        self.profileVM = profileVM
        self._isPresenting = isPresenting
        self._selectedBankAccount = selectedBankAccount
        self._selection = selection
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: spacing) {
                Text(AppTexts.selectBank)
                    .fontCustom(.SemiBold, size: 30)
                    .foregroundColor(.blackColor)
                    .padding([.top, .horizontal], padding)
                
                let count = profileVM.userModel?.banks?.count ?? 0
                if profileVM.profileAPIAS == .ApiHit && count == 0 {
                    EmptyListView(text: AppTexts.noBankAccountsAdded)
                } else if count != 0 {
                    ScrollViewReader { scrollViewReader in
                        List {
                            ForEach(Array((profileVM.userModel?.banks ?? []).enumerated()), id: \.1) { index, bankAccountDetails in
                                BankAccountCell(bankAccountDetails: bankAccountDetails) {
                                    let isSelected = bankAccountDetails?.id == selectedBankAccount?.id
                                    Button {
                                        if !isSelected {
                                            selectedBankAccount = bankAccountDetails
                                        }
                                        isPresenting = false
                                    } label: {
                                        Text(isSelected ? AppTexts.selected : AppTexts.selectBank)
                                            .foregroundColor(isSelected ? .greenColor : .darkGrayColor)
                                            .fontCustom(.Regular, size: 13)
                                    }
                                }.padding([.bottom, .horizontal], padding)
                                    .if(index == 0) { $0.padding(.top, padding) }
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                                self.scrollViewReader = scrollViewReader
                            }
                    }
                } else {
                    Spacer()
                }
                
                MaxWidthButton(text: AppTexts.addBankAccount, fontEnum: .Medium, verticalPadding: 12, cornerRadius: 0) {
                    isPresenting = false
                    selection = NavigationEnum.FillBankDetails.rawValue
                }
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .setNavigationBarTitle(title: AppTexts.bankAccounts)
            .onAppear {
                profileVM.getProfile()
            }
        
        
    }
}

struct SelectBankAccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankAccountSheet(profileVM: ProfileViewModel(),
                        isPresenting: .constant(false),
                        selectedBankAccount: .constant(nil),
                        selection: .constant(nil))
    }
}
