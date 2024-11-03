//
//  ScannerVC.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 01.11.24.
//

import UIKit
import SwiftUI
import VisionKit
import Vision
import AVFoundation

class ScannerVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession?
    weak var delegate: CardScannerDelegate?
    
    private var cardDetails: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let captureSession = self?.captureSession,
                  let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            
            let videoInput: AVCaptureDeviceInput
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .background))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            DispatchQueue.main.async { [weak self] in
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = self?.view.layer.bounds ?? .zero
                previewLayer.videoGravity = .resizeAspectFill
                self?.view.layer.addSublayer(previewLayer)
            }
            
            captureSession.startRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedTextObservation], error == nil else { return }
            
            for observation in results {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                let recognizedText = topCandidate.string
                DispatchQueue.main.async {
                    self?.handleRecognizedText(recognizedText)
                }
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        try? handler.perform([request])
    }
    
    private func handleRecognizedText(_ text: String) {
        let cardNumberPattern = "\\b\\d{4} \\d{4} \\d{4} \\d{4}\\b" // Match card number in 'XXXX XXXX XXXX XXXX' format
        let expiryDatePattern = "\\b\\d{2}/\\d{2}\\b" // Matches 'MM/YY'
        let holderPattern = "[A-Za-z\\s]+" // Matches cardholder name
     

        // Capture card details if matched
        if let cardNumber = text.matches(for: cardNumberPattern).first {
            cardDetails["number"] = cardNumber
        }
        
        if let expiryDate = text.matches(for: expiryDatePattern).first {
            cardDetails["expiryDate"] = expiryDate
        }
        
        if let holderName = text.matches(for: holderPattern).first {
            cardDetails["holder"] = holderName
        }
        

        if cardDetails.count == 3 {
            delegate?.didCaptureCardDetails(
                number: cardDetails["number"] ?? "",
                expiryDate: cardDetails["expiryDate"] ?? "",
                holder: cardDetails["holder"] ?? ""
            )
            // Stop the session after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.captureSession?.stopRunning()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

protocol CardScannerDelegate: AnyObject {
    func didCaptureCardDetails(number: String, expiryDate: String, holder: String)
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch {
            print("Error creating regex: \(error)")
            return []
        }
    }
}
