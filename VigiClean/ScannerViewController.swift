//
//  ScannerViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import AVFoundation
import UIKit

//TODO: Separate in MVP
class ScannerViewController: UIViewController, ScannerView, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: Properties
    var presenter: ScannerViewPresenter!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: Outlets
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var qrScope: UIView!
    
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
            showAlert(with: Scanner.ScannerError.scanNotSupported)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showAlert(with: Scanner.ScannerError.scanNotSupported)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scannerView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    // MARK: methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            presenter.verifyCode(code: stringValue)
        }
    }
    
    func startVibration() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func validCodeFound() {
        captureSession.stopRunning()
        performSegue(withIdentifier: "segueToRequest", sender: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: Actions
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
