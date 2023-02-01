//
//  ScanQRScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI
import CodeScanner

struct ScanQRScreen: View {
    
    @ObservedObject private var cameraVM: CameraViewModel
    
    @State private var showGrantAccessScreen: Bool = false
    @State private var showQRCodeScanner: Bool = false
    
    @Binding private var selection: Int?
    @Binding private var scanResult: String?
    
    private let padding : CGFloat = 16
    private let spacing : CGFloat = 16
    
    init(cameraVM: CameraViewModel,
         selection: Binding<Int?>,
         scanResult: Binding<String?>) {
        self.cameraVM = cameraVM
        self._selection = selection
        self._scanResult = scanResult
    }
    
    var body: some View {
        NavigationLink(isActive: $showGrantAccessScreen, destination: {
            ZStack {
                VStack(spacing: spacing) {
                    Spacer()
                    
                    Text(AppTexts.grantCameraAccessToScanQRCode)
                        .foregroundColor(.blackColor)
                        .fontCustom(.Medium, size: 22)
                        .multilineTextAlignment(.center)
                    
                    MinWidthButton(text: AppTexts.openSettings, fontEnum: .Medium, textSize: 18, horizontalPadding: padding) {
                        cameraVM.showSettingsAlert()
                    }
                    
                    Spacer()
                }.padding(padding)
            }.background(Color.whiteColor.ignoresSafeArea())
                .setNavigationBarTitle(title: AppTexts.scanQR)
            
        }, label: {
            EmptyView()
        }).sheet(isPresented: $showQRCodeScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScanResult(result:))
        }.onAppear {
            cameraVM.requestAccess()
        }.onChange(of: selection) { selection in
            if selection == NavigationEnum.ScanQRScreen.rawValue {
                if cameraVM.hasGrantedRequest {
                    showQRCodeScanner = true
                } else {
                    showGrantAccessScreen = true
                }
                self.selection = nil
            }
        }
    }
    
    private func handleScanResult(result: Result<ScanResult, ScanError>) {
        showQRCodeScanner = false
        
        switch result {
        case .success(let scanResult):
            self.scanResult = scanResult.string
        case .failure(let error):
            switch error {
            case .badInput:
                print("Scanning Failed: The camera could not be accessed. \(error.localizedDescription)")
            case .badOutput:
                print("Scanning Failed: The camera was not capable of scanning the requested codes. \(error.localizedDescription)")
            case .initError(let error):
                print("Scanning Failed: Initialization failed. \(error.localizedDescription)")
            case .permissionDenied:
                print("Scanning Failed: The camera permission is denied. \(error.localizedDescription)")
            }
            self.scanResult = "scanResult.string"
        }
    }
}

struct ScanQRScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRScreen(cameraVM: CameraViewModel(), selection: .constant(0), scanResult: .constant(""))
    }
}
