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
    @Binding var expiryDate: String
    @Binding var cardHolder: String
    @Binding var cvv: String
    var onDismiss: (() -> Void)?
    
    func makeUIViewController(context: Context) -> ScannerVC {
        let scannerViewController = ScannerVC()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CardScannerDelegate {
       
        
        var parent: ScanningCard
        
        init(_ parent: ScanningCard) {
            self.parent = parent
        }
        
        func didCaptureCardDetails(number: String, expiryDate: String,  holder: String) {
            DispatchQueue.main.async {
                self.parent.cardNumber = number
                self.parent.expiryDate = expiryDate
                self.parent.cardHolder = holder
                self.parent.cvv = " "
                self.parent.onDismiss?()
            }
        }
    }
}

