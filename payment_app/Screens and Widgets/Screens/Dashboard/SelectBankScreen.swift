//
//  SelectBankScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 04/01/23.
//

import SwiftUI

struct SelectBankScreen: View {
    
    @ObservedObject private var allBanksVM: AllBanksViewModel
    
    @State private var scrollViewReader: ScrollViewProxy?
    @State private var banksToShow: [BankModel?] = []
    @State private var searchText: String = ""
    
    @Binding private var selectedBank: BankModel?
    @Binding private var isPresenting: Bool
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    init(allBanksVM: AllBanksViewModel,
         selectedBank: Binding<BankModel?>,
         isPresenting: Binding<Bool>) {
        self.allBanksVM = allBanksVM
        self._selectedBank = selectedBank
        self._isPresenting = isPresenting
    }
    
    var body: some View {
        
        ZStack {
            let searchString = Binding<String>(get: {
                self.searchText
            }, set: {
                self.searchText = $0
                if searchText.count > 1 {
                    let searchText = searchText.lowercased()
                    banksToShow = allBanksVM.banks.filter { $0?.name?.lowercased().contains(searchText) == true }
                } else {
                    banksToShow = allBanksVM.banks
                }
            })
            
            VStack(alignment: .leading, spacing: spacing) {
                Text(AppTexts.selectBank)
                    .fontCustom(.SemiBold, size: 30)
                    .foregroundColor(.blackColor)
                    .padding(.top, padding)
                    .padding(.horizontal, padding)
                
                SearchTextField(searchText: searchString)
                    .padding(.horizontal, padding)
                
                let count = banksToShow.count
                if allBanksVM.getBanksAS == ApiStatus.ApiHit && count == 0 {
                    EmptyListView(text: AppTexts.noBanksFound)
                } else if allBanksVM.getBanksAS == ApiStatus.ApiHit || count != 0 {
                    ScrollViewReader { scrollViewReader in
                        List {
                            Section(footer: !allBanksVM.fetchedAllData ?
                                    ListFooterProgressView()
                                    : nil) {
                                ForEach(Array(banksToShow.enumerated()), id: \.1) { index, bank in
                                    Button {
                                        selectedBank = bank
                                        isPresenting = false
                                    } label: {
                                        bankDetail(bank)
                                    }.padding(.bottom, padding)
                                        .if(index == 0) { $0.padding(.top, padding) }
                                        .onAppear {
                                            allBanksVM.paginateWithIndex(index)
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
                    ScrollView {
                        ForEach(0...14, id: \.self) { index in
                            ShimmerView()
                                .frame(height: DeviceDimensions.width * 0.15)
                                .padding(.horizontal, padding / 2)
                                .padding(.bottom, padding)
                                .if(index == 0) { $0.padding(.top, padding) }
                        }.disabled(true)
                    }
                }
            }
        }.background(Color.whiteColor.ignoresSafeArea())
            .onReceive(allBanksVM.$getBanksAS) { apiStatus in
                if apiStatus == .ApiHit {
                    banksToShow = allBanksVM.banks
                }
            }
    }
    
    @ViewBuilder
    private func bankDetail(_ bank: BankModel?) -> some View {
        let size = DeviceDimensions.width * 0.12
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                let bankName = (bank?.name ?? "").capitalized
                AvatarView(character: String(bankName.first ?? " "), size: size)
                
                Text(bankName)
                    .fontCustom(.Medium, size: 16)
                    .foregroundColor(.blackColor)
                
                Spacer()
            }.padding(.horizontal, padding)
            
            Rectangle()
                .fill(Color.blackColor)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.leading, padding + (size/2))
        }
    }
}

struct SelectBankScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankScreen(allBanksVM: AllBanksViewModel(), selectedBank: .constant(nil), isPresenting: .constant(false))
    }
}
