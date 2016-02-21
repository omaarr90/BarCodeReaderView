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

/// The barcode reader view delegates.
public protocol BarcodeReaderViewDelegate {
    
    /**
     This method is called upon a success reading of barcodes.
     
     - Parameters:
        - barcodeReader: The bar code reader view instance which read the barcode.
        - info: the string representations of the barcode.
     */
    func barcodeReader(barcodeReader: BarcodeReaderView, didFinishReadingString info: String)
    
    /**
     This method is called upon a failure.
     
     - Parameters:
        - barcodeReader: The bar code reader view instance which failed.
        - error: NSError which describes the failaure.
            - possible error codes:
                - AccessRestriction: 7000
                - DeviceNotSupported: 7001
                - OutputNotSuppoted: 7002
     */
    func barcodeReader(barcodeReader: BarcodeReaderView, didFailReadingWithError error: NSError)
}

/**
 Barcode types.
 
 - Aztec: AVMetadataObjectTypeAztecCode
 - Code128: AVMetadataObjectTypeCode128Code
 - PDF417Barcode: AVMetadataObjectTypePDF417Code
 - QR: AVMetadataObjectTypeQRCode
 - UPCECode: AVMetadataObjectTypeUPCECode
 - Code39Code: AVMetadataObjectTypeCode39Code
 - Code39Mod43Code: AVMetadataObjectTypeCode39Mod43Code
 - EAN13Code: AVMetadataObjectTypeEAN13Code
 - EAN8Code: AVMetadataObjectTypeEAN8Code
 - Interleaved2of5Code: AVMetadataObjectTypeInterleaved2of5Code
 - ITF14Code: AVMetadataObjectTypeITF14Code
 - DataMatrixCode: AVMetadataObjectTypeDataMatrixCode
 */
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
    
    /// string representations of the bar code type.
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

/// a UIView subclass which can reads barcodes. :)
public class BarcodeReaderView: UIView {
    
    /* public Variables */
    
    ///the delegate which must conform to `BarcodeReaderViewDelegate` protocol
    public var delegate: BarcodeReaderViewDelegate?
    
    /// barcodes type you would like to scan with this instance
    public var barCodeTypes: [BarCodeType]? {
        didSet {
            if nil != self.captureSession {
                self.addMetadataOutputToSession(self.captureSession)
            }
        }
    }

    /* Private Variables */
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var view: UIView?
    
    private var deviceDoesNotSupportVideo: Bool!
    
    //MARK: - initalizers
    
    /**
    initlaize bar code reader view with the specified frame.
    
    - Parameters:
    - frame: CGRect instance to represent the bar code frame.
    
    Returns: a new instance of bar code reader view.
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInitializers()
    }
    /**
     initlaize bar code reader view with the specified decoder. this is for IB
     
     - Parameters:
     - coder: NSCoder instance to decode the view.
     
     Returns: a new instance of bar code reader view.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupInitializers()
    }
    
    /**
     overriden methods from UIView
     */
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.barcodeWillMoveToSuperView()
    }
    
    //MARK: - public functions
    
    /**
    start looking for barcodes. call this method when you are ready to capture some codes
    */
    public func startCapturing() {
        if nil != self.captureSession{
            self.captureSession.startRunning()
        }
    }
    
    /**
     stop looking for barcodes. call this method when you want to stop capturing barcodes
     */
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
    /**
     this method is the delegate mthode of AVCaptureMetadataOutputObjectsDelegate
     */
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
    
    private func barcodeWillMoveToSuperView() {
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
}
