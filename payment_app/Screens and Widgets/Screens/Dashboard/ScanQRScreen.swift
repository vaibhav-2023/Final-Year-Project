//
//  ScanQRScreen.swift
//  payment_app
//
//  Created by MacBook PRO on 07/01/23.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct ScanQRScreen: View {
    
    //MARK: - Variables
    //For Observing View Model sent from Previous Screen updated on 17/01/23
    @ObservedObject private var cameraVM: CameraViewModel
    
    //Variables used for view
    @State private var showGrantAccessScreen: Bool = false
    @State private var showQRCodeScanner: Bool = false
    @State private var torchMode = AVCaptureDevice.TorchMode.off
    
    //Values send from previous screen
    @Binding private var selection: Int?
    @Binding private var scanResult: String?
    
    //constants for spacing and padding
    private let padding : CGFloat = 16
    private let spacing : CGFloat = 16
    
    //MARK: - init
    //Constructor
    init(cameraVM: CameraViewModel,
         selection: Binding<Int?>,
         scanResult: Binding<String?>) {
        self.cameraVM = cameraVM
        self._selection = selection
        self._scanResult = scanResult
    }
    
    //MARK: - Views
    //main view
    var body: some View {
        ZStack {
            NavigationLink(isActive: $showGrantAccessScreen, destination: {
                provideCameraAccessView
            }, label: {
                EmptyView()
            })
            
            NavigationLink(isActive: $showQRCodeScanner, destination: {
                scanQRView
            }, label: {
                EmptyView()
            })
        }.onAppear {
            //on appearing request for camera permission
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
    
    // request for camera access view
    private var provideCameraAccessView: some View {
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
    }
    
    //scan qr code screen
    private var scanQRView: some View {
        ZStack {
            let size = DeviceDimensions.width * 0.7
            //dependency for scanning qr code
            CodeScannerView(codeTypes: [.qr], completion: handleScanResult(result:))
            
            //updated on 19/01/23
            Rectangle()
                .foregroundColor(Color.black.opacity(0.5))
                .mask(SeeThroughShapeView(size: CGSize(width: size, height: size)).fill(style: FillStyle(eoFill: true)))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white, lineWidth: 2)
                    .frame(width: size, height: size))
        }.setNavigationBarTitle(title: AppTexts.scanQR)
            .navigationBarItems(trailing: navigationBarTrailingView)
    }
    
    //navigation bar trailing view
    private var navigationBarTrailingView: some View {
        Button {
            print(torchMode.rawValue)
            toggleFlash()
            print(torchMode.rawValue)
        } label: {
            switch torchMode {
            case .on:
                imageView("flashLightOffIconTemplate")
            case .off:
                imageView("flashLightOnIconTemplate")
            default:
                EmptyView()
            }
        }
    }
    
    //image for showing torch view
    @ViewBuilder
    private func imageView(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundColor(.primaryColor)
    }
    
    //MARK: - Methods
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
            self.scanResult = "Issue in Scan Result"
        }
    }
    
    //for ON/OFF Flash
    private func toggleFlash() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if let device, device.hasTorch {
            do {
                try device.lockForConfiguration()
                switch device.torchMode {
                case .on:
                    device.torchMode = AVCaptureDevice.TorchMode.off
                case .off:
                    device.torchMode = AVCaptureDevice.TorchMode.on
//                    do {
//                        try device.setTorchModeOn(level: 1.0)
//                    } catch {
//                        print("error in \(#function)", error)
//                    }
                default:
                    print("inside default in \(#function)")
                }
                device.unlockForConfiguration()
            } catch {
                print("error in \(#function)", error)
            }
            torchMode = device.torchMode
        }
    }
}

struct ScanQRScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRScreen(cameraVM: CameraViewModel(), selection: .constant(0), scanResult: .constant(""))
    }
}
