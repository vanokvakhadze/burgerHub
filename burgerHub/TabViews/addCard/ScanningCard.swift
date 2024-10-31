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

    class ScannerVC: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var cardNumber: String
        @Binding var cardExDate: String
        @Binding var cardPlaceHolder : String
        @Binding var cardCVV: String

        init(cardNumber: Binding<String>, cardExDate: Binding<String>, cardPlaceHolder: Binding<String>,  cardCVV: Binding<String>) {
            _cardNumber = cardNumber
            _cardExDate = cardExDate
            _cardPlaceHolder = cardPlaceHolder
            _cardCVV = cardCVV
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)
            extractCardDetails(from: scan)
        }

        private func extractCardDetails(from scan: VNDocumentCameraScan) {
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                recognizeText(in: image)
            }
        }

        private func recognizeText(in image: UIImage) {
            let request = VNRecognizeTextRequest { [weak self] request, _ in
                guard let results = request.results as? [VNRecognizedTextObservation] else { return }
                
                for observation in results {
                    if let text = observation.topCandidates(1).first?.string {
                        self?.processDetectedText(text)
                    }
                }
            }
            request.recognitionLevel = .accurate

            if let cgImage = image.cgImage {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                try? handler.perform([request])
            }
        }

        private func processDetectedText(_ text: String) {
            let cardNumberPattern = "\\d{4} \\d{4} \\d{4} \\d{4}"
            let expiryPattern = "\\d{2}/\\d{2}"
            let cvv = "\\d{3}"
            let placeHolder = "[A-Za-z ]{2,}"
            

            if let number = text.matchingPattern(cardNumberPattern) {
                cardNumber = number
            }
            if let expiry = text.matchingPattern(expiryPattern) {
                cardExDate = expiry
                
            }
            
            if let cvvCard = text.matchingPattern(cvv) {
                cardCVV = cvvCard
            }
            
            if text.matchingPattern(placeHolder) != nil{
                cardPlaceHolder = placeHolder
            }
        }
    }
}

extension String {
    func matchingPattern(_ pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        if let match = regex?.firstMatch(in: self, options: [], range: range) {
            return (self as NSString).substring(with: match.range)
        }
        return nil
    }
}

