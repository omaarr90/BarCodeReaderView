//
//  BarCodeReaderView.swift
//  BarCodeReader
//
//  Created by Omar Alshammari on 2/18/16.
//  Copyright © 2016 ___OALSHAMMARI___. All rights reserved.
//

import UIKit
import AVFoundation

private let queueName = "sa.com.elm.AbhserLite.MetadataOutput"

public protocol BarcodeReaderViewDelegate {
    func barcodeReader(barcodeReader: BarcodeReaderView, didFinishReadingString info: String)
    func barcodeReader(barcodeReader: BarcodeReaderView, didFailReadingWithError error: NSError)
}

public enum BarCodeType: String, CustomStringConvertible {
    case Aztec
    case Code128
    case PDF417Barcode
    case QR
    case UPCECode
    case Code39Code
    case Code39Mod43Code
    case EAN13Code
    case EAN8Code
    case Interleaved2of5Code
    case ITF14Code
    case DataMatrixCode
    
    public var description: String {
        get{
            switch self {
            case .Aztec: return AVMetadataObjectTypeAztecCode
            case .Code128: return AVMetadataObjectTypeCode128Code
            case .PDF417Barcode: return AVMetadataObjectTypePDF417Code
            case .QR: return AVMetadataObjectTypeQRCode
            case .UPCECode: return AVMetadataObjectTypeUPCECode
            case .Code39Code: return AVMetadataObjectTypeCode39Code
            case .Code39Mod43Code: return AVMetadataObjectTypeCode39Mod43Code
            case .EAN13Code: return AVMetadataObjectTypeEAN13Code
            case .EAN8Code: return AVMetadataObjectTypeEAN8Code
            case .Interleaved2of5Code: return AVMetadataObjectTypeInterleaved2of5Code
            case .ITF14Code: return AVMetadataObjectTypeITF14Code
            case .DataMatrixCode: return AVMetadataObjectTypeDataMatrixCode
            }
        }
    }
}

public class BarcodeReaderView: UIView {
    
    /* public Variables */
    public var delegate: BarcodeReaderViewDelegate?
    
    public var barCodeTypes: [BarCodeType]? {
        didSet {
            self.addMetadataOutputToSession(self.captureSession)
        }
    }

    /* Private Variables */
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var view: UIView?
    
    private var deviceDoesNotSupportVideo: Bool!
    
    //MARK: - initalizers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInitializers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupInitializers()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if nil != self.captureSession && !deviceDoesNotSupportVideo {
            addPreviewLayerForSession(captureSession)
        } else if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Denied {
            addLabelToViewWithText(NSLocalizedString("You did not allow access to your camera, please allow it to read barcodes.", comment: ""))
            self.delegate?.barcodeReader(self, didFailReadingWithError: NSError.accessRestrictionError())
        } else if deviceDoesNotSupportVideo == true {
            addLabelToViewWithText(NSLocalizedString("Sorry, Your device does not support camera", comment: ""))
            self.delegate?.barcodeReader(self, didFailReadingWithError: NSError.deviceNotSupportedError())
        }
        
    }
    
    //MARK: - public functions
    public func startCapturing() {
        if nil != self.captureSession{
            self.captureSession.startRunning()
        }
    }
    
    public func stopCapturing() {
        if nil != self.captureSession{
            self.captureSession.stopRunning()
        }
    }
    
    public func addView(view: UIView) {
        if self.view != nil {
            self.view!.layer.removeFromSuperlayer()
            self.view = nil
        }
        view.layer.frame = self.bounds
        self.layer.addSublayer(view.layer)
        self.view = view
    }    
}

extension BarcodeReaderView: AVCaptureMetadataOutputObjectsDelegate {
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        let firstObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let readedObject = firstObject, let stringValue = readedObject.stringValue{
                self.delegate?.barcodeReader(self, didFinishReadingString: stringValue)
            }
        }
    }
}

//MARK: - Private functions
private extension BarcodeReaderView {
    private func addLabelToViewWithText(text: String) {
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .Center
        self.addSubview(label)
        
        /* Configure Label AutoLayout */
        let centerYConstraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 8.0)
        
        self.addConstraints([centerYConstraint, leadingConstraint, trailingConstraint])
    }
    
    private func setupInitializers() {
        if let captureSession = newVideoCaptureSession() {
            self.captureSession = captureSession
        }
    }
    
    private func newVideoCaptureSession() -> AVCaptureSession? {
        /* set up a capture input for the default video camera */
        let videoCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCamera)
        } catch {
            deviceDoesNotSupportVideo = true
            return nil
        }
        
        /* attach the input to capture session */
        let captureSession = AVCaptureSession()
        if (!captureSession.canAddInput(videoInput)) {
            return nil
        }
        deviceDoesNotSupportVideo = false
        
        captureSession.addInput(videoInput)
        return captureSession
    }
    
    private func addPreviewLayerForSession(session: AVCaptureSession) {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        let rootLayer = self.layer
        layer.frame = rootLayer.bounds
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        rootLayer.addSublayer(layer)
        layer.cornerRadius = 5.0;
        previewLayer = layer
    }
    
    private func addMetadataOutputToSession(session: AVCaptureSession) {
        let metadataOutput = AVCaptureMetadataOutput()
        if (!session.canAddOutput(metadataOutput)) {
            self.delegate?.barcodeReader(self, didFailReadingWithError: NSError.outputNotSupportedError())
            return
        }
        
        session.addOutput(metadataOutput)
        let queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL)
        metadataOutput.setMetadataObjectsDelegate(self, queue: queue)
        if let allowedTypes = self.barCodeTypes where allowedTypes.count > 0{
            metadataOutput.metadataObjectTypes = self.allowedTypes(allowedTypes)
        } else {
            metadataOutput.metadataObjectTypes = nil
        }
    }
    
    private func allowedTypes(allowed: [BarCodeType]) -> [String] {
        var types = [String]()
        for type in allowed {
            types.append(type.description)
        }
        
        return types
    }
}
