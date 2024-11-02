//
//  ScanningCard.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 01.11.24.
//



import SwiftUI
import VisionKit
import Vision

struct ScanningCard: UIViewControllerRepresentable {
    @Binding var cardNumber: String
    @Binding var cardExDate: String
    @Binding var cardPlaceHolder: String
    @Binding var cardCVV: String
    
    func makeCoordinator() -> ScannerVC {
        ScannerVC(cardNumber: $cardNumber, cardExDate: $cardExDate, cardPlaceHolder: $cardPlaceHolder, cardCVV: $cardCVV)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerVC = VNDocumentCameraViewController()
        scannerVC.delegate = context.coordinator
        return scannerVC
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Scanning failed: \(error.localizedDescription)")
        controller.dismiss(animated: true)
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
}

