//
//  ScannerViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import AVFoundation
import UIKit

// Scans QR code and verifies that object is managed by VigiClean
class ScannerViewController: UIViewController, ScannerView {
    // MARK: Properties
    var presenter: ScannerViewPresenter!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var isAlreadyPresentingAlert: Bool {
        return presentedViewController != nil
    }
    
    // MARK: Outlets
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var qrScope: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var grayOutView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ScannerPresenter(view: self)
        
        captureSession = AVCaptureSession()
        
        qrScope.layer.borderWidth = 3
        qrScope.layer.borderColor = #colorLiteral(red: 0, green: 0.572232604, blue: 0, alpha: 1)
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
                        displayError(message: presenter.convertError(ScannerError.scanNotSupported))
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
                        displayError(message: presenter.convertError(ScannerError.scanNotSupported))
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scannerView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(previewLayer)
        
        if #available(iOS 13, *) {
            // With IOS 13, the segue is not fullscreen and can be dismissed with swipe
            dismissButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) { // Stops captureSession
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    // MARK: methods
    func displayLoadViews(_ statement: Bool) { // displays loadView or not
        if statement {
            captureSession.stopRunning()
        } else {
            captureSession.startRunning()
        }
        activityIndicator.isHidden = !statement
        grayOutView.isHidden = !statement
    }
    
    func correctCodeFound() { // vibrates when a VCCode is found
        if !isAlreadyPresentingAlert {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            presenter.getObject()
        }
    }
    
    func validObjectFound() { // performs segue and hides loadView
        displayLoadViews(false)
        performSegue(withIdentifier: SegueType.request.rawValue, sender: self)
    }
    
    func invalidCodeFound(error: Error) { // returns to dashboard if error
        displayError(message: presenter.convertError(error)) {
            self.performSegue(withIdentifier: SegueType.dashboardUnwind.rawValue, sender: nil)
        }
        displayLoadViews(false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueType.request.rawValue else {
            return
        }
        
        guard let destination = segue.destination as? RequestViewController else {
            return
        }
        
        destination.modalPresentationStyle = .fullScreen
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate { // manages scanner
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            presenter.verifyCode(code: stringValue)
        }
    }
}
